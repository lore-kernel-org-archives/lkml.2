Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2LFJY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:24:56 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45220 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2LFJYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:24:53 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Thu, 6 Dec 2012 10:24:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc8-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121205173415.GI18885@thunk.org> <20121206004234.GA27172@dastard> (sfid-20121206_101901_489446_B4DF2252)
In-Reply-To: <20121206004234.GA27172@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201212061024.41760.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2012 schrieb Dave Chinner:
> > That being said, you'll note that unlike Dave, I have
> > **not** thrown a hissy fit when btrfs grabbed bits from the inode
> > field, even though quite a bit more bits allocated for the inode
> > flags than the fallocate flags.
> 
> IOWs, pointing out that the standard peer review process has been
> bypassed is "throwing a hissy fit"? And Linus calls it "being a
> pissy bitch". To me this is acknoweldgement of the fact that
> something wrong was done, but the actors can't bring themselves to
> directly admit it and so are resorting to name calling and
> blame-shifting to discredit the messenger and therefore the message.

+1

Anyway, the decision seems to be set, so indeed waste of energy to discuss 
it further.

I agree the process is usually fluid. Cause I did not recognize a thread 
like this every day here on this list. And what happened, happened.

But for the future I´d like that patches are posted.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
