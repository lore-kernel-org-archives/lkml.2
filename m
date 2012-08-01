Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2HAOcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:32:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2HAOcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:32:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/6] ARM: ux500: Ensure probing of Audio devices when Device Tree is enabled
Date: Wed, 1 Aug 2012 14:32:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <201208011332.02500.arnd@arndb.de> <5019356E.6020407@linaro.org>
In-Reply-To: <5019356E.6020407@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208011432.02398.arnd@arndb.de>
X-Provags-ID: V02:K0:WlS6ZjkpreCpR9H3XjlxRweQgbniVOOwdHCe5rqEFXm
 tQk4v5Fqrl1YQoW0JAIIlo0MJURoM7X6MHwZ7jNZbuYMbH3GeM
 qcZ+4FgDWG8Fp5vMGsit/Z3yZk8n9AlL5t9FDu2DH1VGG78P6V
 qmyW7kMKX1QF5WU5gaC5wKzFIIOT3cmcJ9T4PGsKClSc8SDzf1
 t4AXBjLapS+x4KinkcRvkJgk0/U1WtmfATZFH36S/9JfOBHteH
 DhGJbchziIGOMjw02CwIaSguKHMW1kXAvMacdX3UfIKAk9pv5D
 c5jp8DeQmH3sKNC6K4eYCHY/PKB286D8NaAz7RGYMK2f2u785k
 XkOwzNf0mBa1ZB229FbY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2012, Lee Jones wrote:
> 
> On 01/08/12 14:32, Arnd Bergmann wrote:
> > On Wednesday 01 August 2012, Lee Jones wrote:
> >>> Looks like you're adding the same call to each of the three cases:
> >>> mop500, snowball and hrefv60+. How about moving it before or after
> >>> the if/elseif block?
> >>
> >> The Snowball one is different 'mop500_msp_init' -> 'mop500_of_msp_init'.
> >
> > Ah, I see. Is there a problem in always using mop500_of_msp_init then?
> > I would guess that this just means you'd have to put the msp into the
> > device tree files, which don't yet exist for mop500 and hrefv60.
> 
> Although that is true, it's only part of the issue.
> 
> mop500_of_msp_init is only a temporary solution to aid in step-by-step 
> enablement of DT for audio. By the end of the patch-set it has been 
> removed (along with the call to it if 'of_machine_is_compatible 
> ("calaosystems,snowball-a9500")'. What I can do it write a patch to 
> consolidate the calls after "ARM: ux500: Remove platform registration 
> of MSP devices", as a bolt-on.

I see. Your solution looks fine then.

	Arnd
