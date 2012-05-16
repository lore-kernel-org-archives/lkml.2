Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967397Ab2EPKyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:54:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967019Ab2EPKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:54:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging tree
Date: Wed, 16 May 2012 10:54:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Greg KH <greg@kroah.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au>
In-Reply-To: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161054.15610.arnd@arndb.de>
X-Provags-ID: V02:K0:egqR9NxvgZ3ImNXqWbsZaMANSid/n4wifh+YivHP4eI
 UL4O7ol/sREdZHA+9EA3WO2JrSD8SoYRI4bJf6kWAC0hrvcCKv
 ktiOoqc2yie096fRHjdQ3pJs63Q/sBGuGyz0WyhFSRV/zkSYoB
 CDVXLZBiUG/9alArnt1wS1dK0QQrKHLf3DbzDjcmodI8V5wIMI
 Wf5v7hhaMrddYQIXHENMd3Pgj4tJuTKl+/0gyQENDe6/8JmtoQ
 y8zac/2zQafeAI8bHdpL9i9q1m3n1lw0PYOEbbgcPT6gnPfSZX
 rG3NUPbAQTzqgBeUrCWWAVIIWY8BT3fj7C/R6CM7KVdQuRtmks
 AMv5JziyIgbllJQBx6F8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/boot/dts/at91sam9g20.dtsi between commit 7cb2e629a240 ("ARM:
> AT91: Add ADC driver to the at91sam9g20 dtsi") from the staging tree and
> commit 5b6089cb6f28 ("ARM: at91: add at91sam9260 DT support") from the
> arm-soc tree.
> 
> So, I didn't know what to do with this, so I used the arm-soc version of
> this file (effectively throwing away the staging tree change).  Hints,
> anyone?

I suspect the addition of the adc node should just go into the
at91sam9260.dtsi file.

	Arnd
