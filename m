Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134Ab1CDAG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:06:29 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:28850 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758875Ab1CDAG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:06:28 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, "'Ewe, Kok Howg'" <kok.howg.ewe@intel.com>,
        "'Lai, Mee Sim'" <mee.sim.lai@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com> <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com> <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com> <20110303185632.GL22940@angua.secretlab.ca>
Subject: RE: About GPIO interrupt function with sysfs
Date: Fri, 4 Mar 2011 09:06:25 +0900
Message-ID: <2BC88E699A3D491E8B7C2B761F8296C7@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
thread-index: AcvZ1Lj7xPDnN68xTmyY1pdXzfP/kQAKHwjQ
In-Reply-To: <20110303185632.GL22940@angua.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

