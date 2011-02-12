Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1BLTLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:11:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1BLTLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:11:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] UniCore32 ISA support for linux-2.6
Date: Sat, 12 Feb 2011 20:11:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
References: <026101cbca54$b95489e0$2bfd9da0$@mprc.pku.edu.cn> <AANLkTim99mRGrMa+n+2AiOXPuf6-xM-dcELUGX0ssMpP@mail.gmail.com>
In-Reply-To: <AANLkTim99mRGrMa+n+2AiOXPuf6-xM-dcELUGX0ssMpP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102122011.34664.arnd@arndb.de>
X-Provags-ID: V02:K0:IIvHtcZ5r3ad2bYCgMwWp428oNv9LNO2nUSBIVGiIku
 E0BaMh1P/iNxZOd0mkrtHlPRG53a4QELCXSvYoAUJBNxe3PqaB
 cP8DjNFpzwt9hmb+8x+aoKbBCzxLX/Wq/Mg3jkNGnLjoUiybKH
 J4P2aPEGcULhbs2Ggz7tfR7MWzWSfN1B7bq9MqpEZULG2y9h7d
 ELTNcmKUiN/aYfeOy4+6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 February 2011 18:51:32 Linus Torvalds wrote:
> On Fri, Feb 11, 2011 at 5:32 PM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> > Hi Linus,
> >  Could you please pull from:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git for_linus
> >  to add unicore32 support for linux-2.6.
> 
> I'm not going to do it during the 38 cycle, but if this has has gotten
> ack's from people like Arnd, and all the commentary from other people
> (like the "the ptrace.c file looks like it was copied from arm, wants
> attribution" etc), I can pull it in the 39 cycle.

I think it should still be posted once more to linux-arch/linux-kernel
as emails. I gave an Acked-by to a number of patches that are
harmless and that I didn't have any comments on.

There are a number of patches that I reviewed more thoroughly, and
Guan did a good job of cleaning up the code based on that. I believe
it's basically good to go into 2.6.39 once they go over the mailing
list in the current version. I'll reply with a Reviewed-by tag to the
patches that I reviewed and that now look ok when that happens.

There are a few remaining issues from the review, which can probably
be addressed in a later version. For instance, I suggested the use
of a flattened device tree for enumerating the nondiscoverable
SoC devices, which should help long-term maintainance, but is not
essential.

I should probably have been clearer about the timing for merging.
While I must have mentioned it at some point, there were a lot of
things I needed to explain about the process, so it probably
got lost.

> Arnd - who else was involved in the reviews? Is there somebody who
> should have been involved and wasn't?

A few people commented on specific patches, but I don't think anyone
besides me looked at all of it. Greg and others reviewed the
device drivers, so I did not bother with those.

I don't know enough about the signal handling code to do a good review,
and I tried to get Al Viro involved at some point, but didn't get his
attention.

	Arnd
