Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1K1Hym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:54:42 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:20933
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab1K1Hyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:54:41 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzz8275ch8275bh8275dhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
Message-ID: <4ED33CDE.4010103@analog.com>
Date: Mon, 28 Nov 2011 08:48:46 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Olof Johansson <olof@lixom.net>,
        Marc Zyngier <maz@misterjones.org>, Ralf Baechle <ralf@linux-mips.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>
Subject: Re: [PATCH] pcmcia: convert drivers/pcmcia/* to use module_platform_driver()
References: <1322369586.2522.3.camel@phoenix>
In-Reply-To: <1322369586.2522.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 05:53 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/pcmcia/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Michael Hennerich<hennerich@blackfin.uclinux.org>
> Cc: Manuel Lauss<manuel.lauss@gmail.com>
> Cc: Olof Johansson<olof@lixom.net>
> Cc: Marc Zyngier<maz@misterjones.org>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>



-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


