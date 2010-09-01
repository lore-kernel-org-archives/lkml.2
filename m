Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab0IAF5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 01:57:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37843 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0IAF5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 01:57:12 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Walker <dwalker@codeaurora.org>
CC: Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Wed, 1 Sep 2010 11:26:43 +0530
Subject: RE: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
Thread-Topic: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
Thread-Index: ActJBq9RBK4QoJIiQAOnwnIi0Hha8QAk2sTw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02CCED0EEC@dbde02.ent.ti.com>
References: <1282926826.5075.21.camel@m0nster>
	 <1282927746.26355.74.camel@e102109-lin.cambridge.arm.com>
	 <1282938790.5075.25.camel@m0nster>
 <1283257116.28248.20.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1283257116.28248.20.camel@e102109-lin.cambridge.arm.com>
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

> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: Tuesday, August 31, 2010 5:49 PM
> To: Daniel Walker
> Cc: Jeff Ohlstein; Russell King; linux-arm-msm@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Tony Lindgren;
> Kirill A. Shutemov; Shilimkar, Santosh
> Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
> 
> On Fri, 2010-08-27 at 20:53 +0100, Daniel Walker wrote:
> > On Fri, 2010-08-27 at 17:49 +0100, Catalin Marinas wrote:
> >
> > > > So your saying it makes more sense to change the msm entry into the
> > > > default entry, and make the current default into the
> > > > ARM11MPCore/Cortex-A9 entry?
> > >
> > > So my opinion is to not add any specific msm code but make the
> > > __v7_setup skip the ACTLR bit setting. Then add an entry for Cortex-A9
> > > to set those bits.
> > >
> >
> > how about this? Naming is of course flexible ..
> 
> I cc'ed Santosh as well. I'm not sure whether TI are using a Cortex-A9
> but with different manufacturer field (I suspect it's still 0x41).
> 
Yep. OMAP4 CA-9 field is 0x41.

Regards,
Santosh
