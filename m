Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0LWJRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:17:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35232 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0LWJRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vb6ntTFRkzOHpeI40vez5RBdiQ4712th0vHuhchpXfbdJDdvybnKhrGUh55KPqQ+yG
         rDhj611Ei4OMTqjfHHxP5avDz2nSEsOuxeMlgr5k4ou9YwsFLn4dYgaNOp6PZivu1e77
         +184LhiJ+s5x5t7eJL/BqDXCLDu7oTDzbC2K8=
MIME-Version: 1.0
In-Reply-To: <m3pqss50lr.fsf@pullcord.laptop.org>
References: <m3pqss50lr.fsf@pullcord.laptop.org>
Date: Thu, 23 Dec 2010 18:17:50 +0900
X-Google-Sender-Auth: YZFC9IY5bRBdNlwTD1q1_Bofcao
Message-ID: <AANLkTine-9YC7062cNaPG+iieBD2bcttx2b3sf3sveKP@mail.gmail.com>
Subject: Re: [GIT PULL] MMC fixes for 2.6.37
From: Kyungmin Park <kmpark@infradead.org>
To: Chris Ball <cjb@laptop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Can you include the s5pc210 external clock support? without this,
s5pc210 boards doesn't use the SDHCI.

I think Ben is busy with other task so can't reply your ack request.

To Ben,
Can you ack the s5pc210 patch?

Thank you,
Kyungmin Park

On Thu, Dec 23, 2010 at 5:56 PM, Chris Ball <cjb@laptop.org> wrote:
> Linus,
>
> Please pull from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus
>
> to fix a regression in resume-from-hibernate, and two minor driver bugs
> on Atmel controllers.  These have been tested in linux-next.  Thanks.
>
> The following changes since commit 0a59228168d3722b71f8e3dbc623316fb4be78f4:
>
>  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2010-12-18 10:28:54 -0800)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus
>
> Nicolas Ferre (1):
>      mmc: atmel-mci: fix multiblock SDIO transfers
>
> Takashi Iwai (1):
>      mmc: Fix re-probing with PM_POST_RESTORE notification
>
> Yauhen Kharuzhy (1):
>      mmc: at91_mci: fix multiblock SDIO transfers
>
>  arch/arm/mach-at91/include/mach/at91_mci.h |    2 ++
>  drivers/mmc/core/core.c                    |    1 +
>  drivers/mmc/host/at91_mci.c                |   13 +++++++++----
>  drivers/mmc/host/atmel-mci.c               |   18 ++++++++++++------
>  4 files changed, 24 insertions(+), 10 deletions(-)
>
> --
> Chris Ball   <cjb@laptop.org>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
