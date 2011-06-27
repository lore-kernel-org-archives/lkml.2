Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab1F0HLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:11:24 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:38637
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072Ab1F0HKn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:10:43 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz936eK1432Nzz1202hzz8275ch8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>
CC: "trivial@kernel.org" <trivial@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Mike Frysinger <vapier@gentoo.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Mon, 27 Jun 2011 08:10:18 +0100
Subject: RE: [PATCH 09/37] Remove unneeded version.h includes from
 drivers/input/
Thread-Topic: [PATCH 09/37] Remove unneeded version.h includes from
 drivers/input/
Thread-Index: Acwx87X/665MqTkTS9uUgK1k6WtcpgCpYGjw
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713EA0AEE78D@LIMKCMBX1.ad.analog.com>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote on 2011-06-24:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/input/.
> This patch removes them.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/input/keyboard/adp5588-keys.c |    1 -
>  drivers/input/keyboard/adp5589-keys.c |    1 -

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif


