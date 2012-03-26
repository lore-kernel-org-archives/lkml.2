Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2CZS5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:57:04 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:34234 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933059Ab2CZS5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:57:03 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Date: Mon, 26 Mar 2012 20:56:35 +0200
Subject: RE: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Thread-Topic: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Thread-Index: Ac0LZe8TqXpIcvznSmaZQB9BvCvUzAAF+3vW
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD1F@MEP-EXCH.meprolight.com>
References: <1332772593-13313-1-git-send-email-alexg@meprolight.com>
	<20120326144712.GA8579@sirena.org.uk>
	<4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD16@MEP-EXCH.meprolight.com>,<20120326153429.GX3098@opensource.wolfsonmicro.com>
In-Reply-To: <20120326153429.GX3098@opensource.wolfsonmicro.com>
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


On Mon, Mar 26, 2012 at 05:28:55PM +0200, Alex Gershgorin wrote:
> On Mon, Mar 26, 2012 at 04:36:33PM +0200, Alex Gershgorin wrote:

> It's not quite true, I was based on the Freescale BSP and I assume,
> that this is checked.  I also tested it on v3.3

> > Uh, presence in a vendor BSP isn't a guarantee of sanity...  Since you
> > didn't specify any consumers the regulator API obviously won't do
> > anything with the voltage range provided but to repeat it's really not
> > at all obvious that anything sane ever would.

Thanks Mark I think that understand you,
if not have consumers do not set ranges.
I will correct it

Thanks 
Alex Gershgorin



