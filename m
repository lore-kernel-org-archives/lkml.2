Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1FXKld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:41:33 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:3554 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1FXKlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:41:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFxpBE6Q/khM/2dsb2JhbABSpzV3rEeeGIYtBJZsiyM
X-IronPort-AV: E=Sophos;i="4.65,418,1304294400"; 
   d="scan'208";a="97696168"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] Add support for the Philips SA56004 temperature sensor.
Date: Fri, 24 Jun 2011 12:40:57 +0200
Message-ID: <6E4D2678AC543844917CA081C9D6B33F04C74F28@XMB-AMS-103.cisco.com>
In-Reply-To: <20110606124047.GA26180@ericsson.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3] Add support for the Philips SA56004 temperature sensor.
Thread-Index: AcwkRxuKHycGJO8TT3iq/VMBpyOm7gOFAWEA
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com> <20110606124047.GA26180@ericsson.com>
From: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
To: "Guenter Roeck" <guenter.roeck@ericsson.com>
Cc: <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Jun 2011 10:41:29.0056 (UTC) FILETIME=[46591E00:01CC325B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Is anything being done with this patch, yet?
I haven't heard anything from Jean so far.

Thanks,
Stijn

> -----Original Message-----
> From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> Sent: maandag 6 juni 2011 14:41
> To: Stijn Devriendt (sdevrien)
> Cc: khali@linux-fr.org; lm-sensors@lm-sensors.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v3] Add support for the Philips SA56004
temperature
> sensor.
> 
> On Mon, Jun 06, 2011 at 06:40:45AM -0400, sdevrien@cisco.com wrote:
> > From: Stijn Devriendt <sdevrien@cisco.com>
> >
> > Add support for the Philips SA56004, an LM86
> > compatible temperature sensor.
> >
> > Changes since v2:
> > - Changed BUG_ON to WARN_ON
> > Changes since v1:
> > - Updated documentation
> > - Trace replaced by BUG_ON
> > - style updates
> >
> > Signed-off-by: Stijn Devriendt <sdevrien@cisco.com>
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Jean, do you want to take this and/or have a look, or should I ?
> 
> Thanks,
> Guenter
