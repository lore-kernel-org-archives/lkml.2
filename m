Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0HCNCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:02:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47377 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0HCNCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=qNVeIlTzozhY9MXH5PHYIsAL8T7zOBZ+0hWrBlbEy0PiBHW1AAv9nNd6FspugBZVUW
         q7iPmhg0n6Oa3KFBNjs42dInyCPUqiQs10rGTQCJsSVITmZ/NA9sf8FFbI+Dg7xQiJKj
         TN/8W0tBK9mUiqVvoO1avTKG1hqyMwTdMqlaM=
MIME-Version: 1.0
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com>
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> 
	<AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com> 
	<4381.1280815590@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com>
From: Timur Tabi <timur@freescale.com>
Date: Tue, 3 Aug 2010 08:01:51 -0500
X-Google-Sender-Auth: lBedzmn1VMYh0pQjuCJuDw-lNh8
Message-ID: <AANLkTinpwYnyc1oN1VbtBgUF6bk6E5q_Gq1Dj3WXV3wc@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Michael Neuling <mikey@neuling.org>,
        Alexandre Bounine <abounine@tundra.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, thomas.moll@sysgo.com,
        Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 7:17 AM, Bounine, Alexandre
<Alexandre.Bounine@idt.com> wrote:
> This happened after change to book-e definitions.
> There are patches that address this issue.

And those patches should have been applied before 2.6.35 was released.
 Someone dropped the ball.  2.6.35 is broken for a number of PowerPC
boards:

$ make mpc85xx_defconfig
...
$ make
...
  CC      arch/powerpc/sysdev/fsl_rio.o
arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
arch/powerpc/sysdev/fsl_rio.c:248: error: 'MCSR_MASK' undeclared
(first use in this function)
arch/powerpc/sysdev/fsl_rio.c:248: error: (Each undeclared identifier
is reported only once
arch/powerpc/sysdev/fsl_rio.c:248: error: for each function it appears in.)
make[1]: *** [arch/powerpc/sysdev/fsl_rio.o] Error 1

-- 
Timur Tabi
Linux kernel developer at Freescale
