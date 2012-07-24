Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2GXIS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:18:57 -0400
Received: from Smtp1.Lantiq.com ([195.219.66.200]:41901 "EHLO smtp1.lantiq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab2GXISz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:18:55 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 04:18:54 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUEAM1XDlAKQLW9/2dsb2JhbABFhSy1RoIhAQEEeRACAQgNARQkHxMlAgQBDQUIxQuRXmADiBmEfo4vjG8
X-IronPort-AV: E=McAfee;i="5400,1158,6781"; a="471328"
From: "Langer Thomas (LQDE RD ST PON SW)" <thomas.langer@lantiq.com>
To: John Crispin <blogic@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/6] GPIO: MIPS: add gpio driver for flacon SoC
Thread-Topic: [PATCH 5/6] GPIO: MIPS: add gpio driver for flacon SoC
Thread-Index: AQHNaWjRoxClG1MIpUeb+lH78STomZc4Ezxw
Date: Tue, 24 Jul 2012 08:09:33 +0000
Message-ID: <593AEF6C47F46446852B067021A273D6060CEA@MUCSE039.lantiq.com>
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
 <1343112660-12245-5-git-send-email-blogic@openwrt.org>
In-Reply-To: <1343112660-12245-5-git-send-email-blogic@openwrt.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.174.68]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

John Crispin wrote on 2012-07-24:
> Add driver for GPIO blocks found on Lantiq FALCON SoC. The SoC has 5
> banks of up to 32 pads. The GPIO blocks have a per pin IRQs.
> 
> Signed-off-by: John Crispin <blogic@openwrt.org>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/mips/include/asm/mach-lantiq/gpio.h |    4 +
>  drivers/gpio/Kconfig                     |    5 +
>  drivers/gpio/Makefile                    |    1 +
>  drivers/gpio/gpio-falcon.c               |  355 ++++++++++++++++++++++++++++++
>  4 files changed, 365 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-falcon.c

Please fix the spelling error in the subject!

Best Regards,
Thomas


