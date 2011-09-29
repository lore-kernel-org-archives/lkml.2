Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1I2B1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:27:03 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:38327 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1I2B1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:27:02 -0400
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Sep 2011 21:27:02 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20099.50407.346360.216442@quad.stoffel.home>
Date: Wed, 28 Sep 2011 21:07:51 -0400
From: "John Stoffel" <john@stoffel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Will Drewry <wad@chromium.org>, Mandeep Singh Baines <msb@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
        dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: verity target
In-Reply-To: <21505.1317245414@turing-police.cc.vt.edu>
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
	<CABqD9hYWK2czEKN87xDu7YPbRcp9xrumJ5PZ8aQTzBLafrnBMw@mail.gmail.com>
	<21505.1317245414@turing-police.cc.vt.edu>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Valdis" == Valdis Kletnieks <Valdis.Kletnieks@vt.edu> writes:

Valdis> On Tue, 27 Sep 2011 14:02:05 CDT, Will Drewry said:
>> I was just curious if there is any interest in pulling this change, or
>> if not, if there is any particular set of concerns, fixes, etc.

Valdis> Out of curiosity, how much of the stack does this end up eating?  My root
Valdis> filesystem is already ext4 on an LVM partition that's on a LUKS/dm-crypt
Valdis> partition on a hard drive, and I'm sure somebody out there will have used xfs
Valdis> instead - and then exported it via NFS or something. Are we going to get weird
Valdis> stack overflows if people throw dm-verity into this sort of mix?

>> realize it's not a small amount of code to digest (though it is
>> smaller than the post from last year[1]).   Would re-posting with an
>> added blob explaining the name be useful,

Valdis> Probably will need it to be merged, unless you set up an
Valdis> auto-reply that says "Patch rejected, 'verity' is *not* a typo
Valdis> for 'verify'" ;)

God, I've been reading this as veriFy all along.  I think your name
stinks because it's too close to Verify, and too obscure otherwise.

John
