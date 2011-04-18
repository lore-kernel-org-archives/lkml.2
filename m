Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1DRInI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:43:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33513 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1DRInE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QRI/kNjpCXomFU2FSgwYn0K0FlDyh6U+K5N2PO6jgViV7y/XwL2aLXXcyo2sWraTyB
         ghD20BhQb9laabPdll203pSgE59l0vDi/qkvvt8twldz38FNt1aZKZvpW6rwd3+36vKf
         l8q/hx2gNkyC3Jz9dDJyQtWoqxbFNsQ8oGfkU=
MIME-Version: 1.0
In-Reply-To: <008701cbfd45$94dd8f70$be98ae50$%kim@samsung.com>
References: <008701cbfd45$94dd8f70$be98ae50$%kim@samsung.com>
Date: Mon, 18 Apr 2011 17:43:00 +0900
X-Google-Sender-Auth: iCDYQ-sDqv6RqFmVPR-tm7tnfmI
Message-ID: <BANLkTik=-YbSD3D+9twqDm3uKR3tm+V+=g@mail.gmail.com>
Subject: Re: [GIT PULL] Samsung fixes for 2.6.39-rc4
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you check this patch also?
http://lists.arm.linux.org.uk/lurker/message/20110329.064902.fb2f620c.en.html

Fix cpuinit section mismatch(es).

WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Thank you,
Kyungmin Park

On Mon, Apr 18, 2011 at 6:22 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Hi Linus,
>
> Please pull Samsung fixes from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> These things are small fixes for 2.6.39-rc4.
> If any problems, please let me know.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
> The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:
>
>  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)
>
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> Abhilash Kesavan (2):
>      ARM: S5P: Remove unused s3c_pm_check_resume_pin
>      ARM: SAMSUNG: Fix build failure in PM CRC check code
>
> Maurus Cuelenaere (1):
>      ARM: SAMSUNG: Fix warning 's3c_pm_show_resume_irqs' defined but not
> used
>
>  arch/arm/plat-s5p/pm.c           |   11 -----------
>  arch/arm/plat-samsung/pm-check.c |    6 ------
>  arch/arm/plat-samsung/pm.c       |    5 +++--
>  3 files changed, 3 insertions(+), 19 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
