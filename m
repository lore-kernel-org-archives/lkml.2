Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab1ANSAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:00:18 -0500
Received: from THUNK.ORG ([69.25.196.29]:55827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1ANSAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:00:11 -0500
Date: Fri, 14 Jan 2011 12:59:42 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Milan Broz <mbroz@redhat.com>,
        Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110114175942.GK31800@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
	NeilBrown <neilb@suse.de>, Milan Broz <mbroz@redhat.com>,
	Karel Zak <kzak@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
 <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org>
 <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
 <20110114071858.7eee145c@notabene.brown>
 <20110113204145.GC31800@thunk.org>
 <20110114162022.GC978@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114162022.GC978@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 05:20:22PM +0100, Tejun Heo wrote:
> 
> Hmmm... that's already possible with the existing holders symlinks,
> right?  As Kay said in another message, I don't think we can do
> anything about the symlinks at this point.  It already has userland
> users, so we'll have to maintain them and there's no reason to create
> something else for the same functionality.

Yes, agreed.  My point was that if we have a better system, we could
migrate blkid and other users to new interface, and maybe in a few
years, we can deprecate that interface.  So we do have to maintain
them for at least the medium term, but that shouldn't stop us from
divising a better interface, and then gradually migrating systems to
use that newer and better interface.

						- Ted
