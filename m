Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2CZMg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 08:36:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2CZMg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 08:36:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] rtc/spear: Add Device Tree probing capability
Date: Mon, 26 Mar 2012 12:36:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Viresh Kumar <viresh.kumar@st.com>, akpm@linux-foundation.org,
        devicetree-discuss@lists.ozlabs.org, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, spear-devel@list.st.com, viresh.linux@gmail.com,
        Rob Herring <robherring2@gmail.com>
References: <8747a4b3bdcfb7b3384c14ca909228e1164d0fc5.1332755275.git.viresh.kumar@st.com> <201203261332.02073.sr@denx.de>
In-Reply-To: <201203261332.02073.sr@denx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203261236.05037.arnd@arndb.de>
X-Provags-ID: V02:K0:EyVckJ0EtUvKrqFdolaNQQwlkpgCHs6dPDz+Iyq4f/y
 oWdzqKk2tVCuaVxjWdxqtFqCFp4d8E9iIw6sVLK8fTp+JxiMb+
 E7sH1o6o4mgK04P9d5ATmHNqgaLizKLVD1q1egAL/HbQCqWALl
 Ec+tM5n22F9DBVGA/rqB72n8qNA8URLIAkDlRfJ6lNh8riG5gA
 W8M01L/7Ncx4d40zPYAeW5SLJrSEDSS9zietIDyzLcb0x63b6L
 wcukuKVug4yhz44ifMm1di88+kNxOnrTU61a37NlPZ//OjVgOA
 JiU1wmsbj1OF2R/iQQ1TyIQxAlmMLzhfhjyi30ZYExCB1DHC7w
 dVf17uRlVraMqHYgU8XU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2012, Stefan Roese wrote:
> > diff --git a/Documentation/devicetree/bindings/rtc/spear-rtc.txt
> > b/Documentation/devicetree/bindings/rtc/spear-rtc.txt new file mode 100644
> > index 0000000..928410f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/spear-rtc.txt
> > @@ -0,0 +1,18 @@
> > +* SPEAr RTC
> > +
> > +Required properties:
> > +- compatible : "st,spear-rtc"
> > +- reg : Address range of the rtc registers
> > +- interrupt-parent: Should be the phandle for the interrupt controller
> > +  that services interrupts for this device
> > +- interrupt: Should contain the rtc interrupt number
> > +
> > +Example:
> > +
> > +     rtc@fc000000 {
> > +             compatible = "st,spear-rtc";
> 
> With Rob's comments in mind, wouldn't it be better to use a more specific 
> compatible property? Should we stick with "st,spear600-rtc"? Or use "st-
> spear300-rtc" as "oldest" SoC variant?

I wouldn't mind if you list all three, or at least spear600 as the actual
chip and spear300 as the one that introduced the device. Of course, if the
device itself is licensed from some other vendor or was used in a prior product,
I would list that one.

	Arnd
