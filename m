Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2JYLG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:06:58 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:34299 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2JYLG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:06:57 -0400
From: Nix <nix@esperi.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>, Peng Tao <bergwolf@gmail.com>,
        Trond.Myklebust@netapp.com, gregkh@linuxfoundation.org,
        Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount)
References: <20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org> <87y5iv78op.fsf_-_@spindle.srvr.nix>
	<20121025011056.GC4559@thunk.org>
Emacs: if it payed rent for disk space, you'd be rich.
Date: Thu, 25 Oct 2012 12:06:42 +0100
In-Reply-To: <20121025011056.GC4559@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 21:10:56 -0400")
Message-ID: <871ugm6cal.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=10 Fuz1=10 Fuz2=10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Oct 2012, Theodore Ts'o stated:
> Also, can you reproduce the problem with the nobarrier and
> journal_async_commit options *removed*?  Yes, I know you have battery
> backup, but it would be interesting to see if the problem shows up in
> the default configuration with none of the more specialist options.
> (So it would probably be good to test with journal_checksum removed as
> well.)

I'm going to spend some time after work today trying to reproduce this
in a virtual machine. If rebooting while umounting is truly all it
takes, as it seems, this should eliminate a bunch of variables and make
it a lot easier to reproduce. (Assuming Eric hasn't already done just
that, that is.)

-- 
NULL && (void)
