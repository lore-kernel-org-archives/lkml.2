Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1LDCgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 21:36:08 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:49992
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925Ab1LDCgE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 21:36:04 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: Ondrej Zary <linux@rainbow-software.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3.1] [resend] Resurrect Intel740 driver: i740fb
Thread-Topic: [PATCH v3.1] [resend] Resurrect Intel740 driver: i740fb
Thread-Index: AQHMsi104CE7BDJwvU6UiIsNpHBCcg==
Date: Sun, 4 Dec 2011 02:35:59 +0000
Message-ID: <CAOZdJXWp24Kday8vt6vXsr6bYbVyLmMqrFfY_n7kboKpj0a8Ug@mail.gmail.com>
References: <201111182154.45139.linux@rainbow-software.org>
	<4EDA9882.208@gmx.de>
In-Reply-To: <4EDA9882.208@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <EA0510C25958EB4ABA8FA49D5F681F9A@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 3:45 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
>
>> +     return !!(i740inreg(par, XRX, REG_DDC_STATE) & DDC_SCL);
>
> Why "!!"?

This is a trick that guarantees that the return value is either 0 or
1.  Without the !!, the return value will be either 0 or DDC_SCL.

-- 
Timur Tabi
Linux kernel developer at Freescale
