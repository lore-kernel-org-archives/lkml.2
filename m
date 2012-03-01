Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030996Ab2CAN4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:56:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030782Ab2CAN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:56:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] sizes.h: move from asm-generic to <linux/sizes.h>
Date: Thu, 1 Mar 2012 13:55:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>
References: <cover.1330607068.git.rubini@gnudd.com> <7bbc4b3dc5a9fadfe7d8ce3f9846b03ada68424e.1330607068.git.rubini@gnudd.com>
In-Reply-To: <7bbc4b3dc5a9fadfe7d8ce3f9846b03ada68424e.1330607068.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203011355.57356.arnd@arndb.de>
X-Provags-ID: V02:K0:lsfZ9Q3BAGn/OaxvaKEV1cUclWOY59ul//svXpc0Cb+
 gsmSQ0s/PLxeQNgrW2Vw8DO9o6+qynHtnYpjrJENZa2ysuZx5A
 HCmg1Da7/0Mm3sQYh6PP4RTML9IOJgOEcq8KTe3EI/vNjVTod0
 rkgrUWQZOeUmAqAE+JQ4sHPxpwRPWdnQHM7xko+b7M5rEU5LMr
 Zr1zl+WI5SGuq0B4ib2/VMjqP1lyeWx3piUN2l5zkjKffXLjfy
 3Yubd+7AXl6HJdLy1dfPGQYoRYDVB+iaPQMnB3aApzXCmYqnMK
 jsSPXL2d23QC4QyjjZ/0MCn/FQyAd/frncXg70bC6YGmNdSY5v
 Shqmd1LtexLC3AhfiM40=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Alessandro Rubini wrote:
> sizes.h is used throughout the AMBA code and drivers, so the header
> should be available to everyone in order to driver AMBA/PrimeCell
> peripherals behind a PCI bridge where the host can be any platform
> (I'm doing it under x86).
> 
> At this step <asm-generic/sizes.h> includes <linux/sizes.h>,
> to allow a grace period for both in-tree and out-of-tree drivers.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Alan Cox <alan@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

For the asm-generic part of this.
