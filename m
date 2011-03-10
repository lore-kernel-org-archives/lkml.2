Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1CJPNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:13:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:4065 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab1CJPNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:13:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,296,1297065600"; 
   d="scan'208";a="400651071"
From: "Lai, Mee Sim" <mee.sim.lai@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
Date: Thu, 10 Mar 2011 23:13:05 +0800
Subject: RE: About GPIO interrupt function with sysfs
Thread-Topic: About GPIO interrupt function with sysfs
Thread-Index: AcvZ1Lj7xPDnN68xTmyY1pdXzfP/kQAKHwjQAU4ZP0A=
Message-ID: <1FCD1EEA68DED942B626C91DF9B9AA81271FE6C238@pgsmsx502.gar.corp.intel.com>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com>
 <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
 <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
 <20110303185632.GL22940@angua.secretlab.ca>
 <2BC88E699A3D491E8B7C2B761F8296C7@hacdom.okisemi.com>
In-Reply-To: <2BC88E699A3D491E8B7C2B761F8296C7@hacdom.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,
Is there any update on this? thanks!

Thanks & Regards,
Michelle Lai Mee Sim
Software Platform Application Engineer
inet:82532218

-----Original Message-----
From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
Sent: Friday, March 04, 2011 8:06 AM
To: 'Grant Likely'
Cc: linux-kernel@vger.kernel.org; Ewe, Kok Howg; Lai, Mee Sim; 'Toshiharu Okada'
Subject: RE: About GPIO interrupt function with sysfs

Hi Grant, 

On Friday, March 04, 2011 3:57 AM, Grant Likely wrote:
> I don't know.  I'll need to dig into that code before I can 
> answer.  I suggest digging into it yourself to figure out the 
> answer as I cannot promise that I'll get to it anytime soon.

Seeing "gpio_to_irq" of another architecture (e.g. ARM), there is significant code in it.
In addition, you can see "Not implemented, yet" description in "arch/x86/include/asm/gpio.h"
Thus, I suspect that x86 GPIO sysfs can't support interrupt function at present.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

