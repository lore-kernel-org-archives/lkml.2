Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab0GUPFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:05:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab0GUPFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XOlUFgyn1vdaI5WPuB+dHOgi7IkCkq6iur0y9D6SxmnBNRV32w1wdqc63km4tAWEZ8
         VnNq5zarMCuTM5lKX+L0BkhvBsTbj8XuKSXIvV6PcfPd+07iHvrzy5Ug3CQhCyof8ZxC
         RfEl7MnCq9Girx1rfqVCOjaFFpAsWK6Jdan4o=
MIME-Version: 1.0
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A53043F0B2C09@dlee03.ent.ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
	<1278975369-7687-9-git-send-email-nm@ti.com>
	<27F9C60D11D683428E133F85D2BB4A53043F0B2C09@dlee03.ent.ti.com>
Date: Wed, 21 Jul 2010 10:05:43 -0500
X-Google-Sender-Auth: MX_ngYlf04U85IvyEJjZUvosWzI
Message-ID: <AANLkTilRVJ5gZ-HGExhPjeO553FSRJ0wiRBOcY0pQHjp@mail.gmail.com>
Subject: Re: [PATCH 08/11] staging: tidspbridge: remove IN modifier
From: Nishanth Menon <nm@ti.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 9:59 AM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
> Hi,
>
>>From: Menon, Nishanth
>>
>>IN modifier does not exist. remove it
>>
>>Signed-off-by: Nishanth Menon <nm@ti.com>
>>---
> [...]
>>diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h
>>b/drivers/staging/tidspbridge/include/dspbridge/drv.h
>>index 020bed0..753a317 100644
>>--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
>>+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
>>@@ -70,8 +70,8 @@
>> #define OMAP_DMMU_BASE 0x5D000000
>> #define OMAP_DMMU_SIZE 0x1000
>>
>>-#define OMAP_PRCM_VDD1_DOMAIN 1
>>-#define OMAP_PRCM_VDD2_DOMAIN 2
>>+#define OMAP_PRCM_VDD1_DOMA1
>>+#define OMAP_PRCM_VDD2_DOMA2
>>
>
> Unexpected change?

wooops... Sorry about that..
>
> Regards,
>
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
