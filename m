Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2EaR50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:57:26 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:17559 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2EaR5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:57:25 -0400
From: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: RE: [PATCH 4/4] regmap: Minor optimisation for _regmap_raw_write().
Thread-Topic: [PATCH 4/4] regmap: Minor optimisation for _regmap_raw_write().
Thread-Index: AQHNP0yhMHwI1+aD50OFJd98bGbbQJbkLfyQ
Date: Thu, 31 May 2012 17:57:17 +0000
Message-ID: <751C305CD2876B4990194D0512DE8BF2441CA8D6@SW-EX-MBX01.diasemi.com>
References: <201205311622.q4VGMHGe015484@sw-eng-lt-dc-vm2>
 <20120531164419.GL2666@opensource.wolfsonmicro.com>
In-Reply-To: <20120531164419.GL2666@opensource.wolfsonmicro.com>
Accept-Language: pl-PL, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 31, 2012 at 05:11:38PM +0200, Krystian Garbaciak wrote:
> > Just to make things simplier inside the function.
> 
> Again, what is this actually doing (ie, please improve your changelogs)?
> 
> It looks like it's just factoring constants out (which hopefully the compiler can do
> but still is OK) - this looks good but should probably be at the start rather than
> end of the series.

Yes, this is only to make the code a bit simpler. I will put it as a first patch then.

Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail
