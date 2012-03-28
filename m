Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2C1MU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:20:57 -0400
Received: from mail.meprolight.com ([194.90.149.17]:60717 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751227Ab2C1MU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:20:56 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Fabio Estevam <festevam@gmail.com>
CC: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 28 Mar 2012 14:20:27 +0200
Subject: RE: [PATCH v2] regulator: i.MX35-PDK Add regulator support
Thread-Topic: [PATCH v2] regulator: i.MX35-PDK Add regulator support
Thread-Index: Ac0M3AYia0/btYDDTomiIRnMJErwzgAAEuiQ
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD22@MEP-EXCH.meprolight.com>
References: <1332935527-21414-1-git-send-email-alexg@meprolight.com>,<CAOMZO5DE0wcdbk7xbXuOFKJ=NNtSrWTPaLjRAdDfewOmPR-eVw@mail.gmail.com>
In-Reply-To: <CAOMZO5DE0wcdbk7xbXuOFKJ=NNtSrWTPaLjRAdDfewOmPR-eVw@mail.gmail.com>
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

Hi Fabio,

Thanks for you comments,

On Wed, Mar 28, 2012 at 8:52 AM, Alex Gershgorin <alexg@meprolight.com> wrote:
> This version rebased for v3.4, also removes ranges from regulators
> who do not have consumers and adds consumers for same regulators.

> > In your subject: prefix it with "ARM" as this patch should go via the arm tree.

> > Also, do not put comments about kernel version in the commit log.
> > If you want to talk about kernel version/patch history you can do so
> > below the --- line.

I will take note of this 
...
> +static struct regulator_consumer_supply vcam_consumers[] = {
> +       /* sgtl5000 */
> +       REGULATOR_SUPPLY("VDDA", "1-000a"),

> > This should be "0-000a" instead.

oops... I will correct this 


