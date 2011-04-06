Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab1DFQJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:09:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53667 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1DFQJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YSprR4QTaLcOGxFWd2YWSDTlrOprXe44602ADrt0LqYvl0lHLfEDlpMGXQywC1rSn5
         ppz9Bayn1ktdDs0ZoW0i4N6LQ80V271zKbrrneFRBSRwjPjE99vbYqZKxZf4J9QIGrn9
         icWtYbL8aWQfDxl+QaS0B1//hM+7N3brP71Go=
MIME-Version: 1.0
In-Reply-To: <20110406110335.0f2d5f4c@schlenkerla.am.freescale.net>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
	<1302022702-24541-2-git-send-email-justinmattock@gmail.com>
	<20110405131504.1d182da4@schlenkerla.am.freescale.net>
	<BANLkTi=5A1P-WAFvCyjbT7RVva9K9d=gQQ@mail.gmail.com>
	<20110406110335.0f2d5f4c@schlenkerla.am.freescale.net>
Date: Wed, 6 Apr 2011 09:09:14 -0700
Message-ID: <BANLkTi=CRxJqYdtD-kjA3buuWqYiSJEzxQ@mail.gmail.com>
Subject: Re: [RFC 2/5]arch:powerpc:sysdev:Makefile Remove unused config in the Makefile.
From: Justin Mattock <justinmattock@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: trivial@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Harninder Rai <harninder.rai@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 9:03 AM, Scott Wood <scottwood@freescale.com> wrote:
> On Wed, 6 Apr 2011 08:07:58 -0700
> Justin Mattock <justinmattock@gmail.com> wrote:
>
>> ahh.. so the:  fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o is still in use
>> even though FSL_85XX_CACHE_SRAM is not really used, but really is used!!
>>
>> but might be wrong with this.
>
> More like there are plans to use it, or possibly out-of-tree users.  We
> should prod people a bit to submit the driver patches that use this before
> we just yank it out.
>
> -Scott
>
>

well if this is going to be used for something down the line, then
best leave it in..

-- 
Justin P. Mattock
