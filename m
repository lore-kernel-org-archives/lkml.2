Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2GaGlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:41:50 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:24435
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab2GaGlr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:41:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I542Mzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Singh Sandeep-B37400 <B37400@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Francois Romieu <romieu@fr.zoreil.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
Thread-Topic: [2/3][PATCH][v2] TDM Framework
Thread-Index: AQHNbADsHRsnZfKnik2om4CTBsszqJc9k/oAgAS8jgCAAKZH8A==
Date: Tue, 31 Jul 2012 06:41:41 +0000
Message-ID: <3F1D9DCAAB49B94D88DBE05911FA4E6E511B93@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727152542.GB1613@electric-eye.fr.zoreil.com>
 <20120730154536.GA3218@sirena.org.uk>
In-Reply-To: <20120730154536.GA3218@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Monday, July 30, 2012 9:16 PM
To: Francois Romieu
Cc: Singh Sandeep-B37400; devel@driverdev.osuosl.org; linuxppc-dev@lists.ozlabs.org; galak@kernel.crashing.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
Subject: Re: [2/3][PATCH][v2] TDM Framework

On Fri, Jul 27, 2012 at 05:25:42PM +0200, Francois Romieu wrote:

> 2. It would probably make sense to Cc: netdev and serial. There may be
>    some kernel client network integration from the start.

Plus audio, quite a few of the buses mentioned as examples of use cases for the hardware are audio ones.
[Sandeep] Ok


