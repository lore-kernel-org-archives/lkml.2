Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1CKAHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:07:23 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47042 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090Ab1CKAHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:07:22 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Rabin Vincent'" <rabin@rab.in>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>,
        "'Ewe, Kok Howg'" <kok.howg.ewe@intel.com>,
        "'Lai, Mee Sim'" <mee.sim.lai@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com> <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com> <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com> <AANLkTimAQoUw1okbB7hSz7bxF7XwjwERLzh8QFTS01m0@mail.gmail.com>
Subject: RE: About GPIO interrupt function with sysfs
Date: Fri, 11 Mar 2011 09:07:18 +0900
Message-ID: <6E54221960DF4E11A91A2F6BFDDD7D69@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvfOzqiXLg5+YD7TRyfHj3eU8kdDQAQzV4g
In-Reply-To: <AANLkTimAQoUw1okbB7hSz7bxF7XwjwERLzh8QFTS01m0@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Rabin,

Friday, March 11, 2011 12:52 AM, Rabin Vincent wrote:
> That's not what is in latest mainline:

Thank you for your information.
I could confirm the latest mainline (2.6.38-rc8) "gpio_to_irq" has meaningful processing.
(I have used the latest stable kernel "2.6.37" series. )

Thanks!
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

