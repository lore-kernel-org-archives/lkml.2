Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2JQGL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:11:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44370 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab2JQGLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:11:25 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH RESEND 0/8] TI Touchscreen driver updates and Support
 for TSC/ADC MFD driver
Thread-Topic: [PATCH RESEND 0/8] TI Touchscreen driver updates and Support
 for TSC/ADC MFD driver
Thread-Index: AQHNq3HBvcHo13jSVku2BGv0P3D9i5e72AiAgAEruEA=
Date: Wed, 17 Oct 2012 06:11:13 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E960D9B@DBDE01.ent.ti.com>
References: <1350372345-27108-1-git-send-email-rachna@ti.com>
 <20121016174207.GA1833@core.coreip.homeip.net>
In-Reply-To: <20121016174207.GA1833@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I have got an ACK from Jonathan and Dmitry on this patch series.
Can you please pull in if there are no further review comments.

Regards,
Rachna.

On Tue, Oct 16, 2012 at 23:12:07, Dmitry Torokhov wrote:
> Hi Rachna,
> 
> On Tue, Oct 16, 2012 at 12:55:37PM +0530, Patil, Rachna wrote:
> > This patch set is a cumulative set of [1] and [2] sent earlier.
> > I have merged the patch set so that the MFD patches apply without any 
> > issues.
> > 
> > Also Note that there are no code changes in either of the patch set, 
> > only rebased on top of linux-next to make sure that all the patches 
> > apply without any conflicts.
> > 
> > This patch set has been tested on AM335x EVM.
> > 
> > [1] "[PATCH 0/4] input: TSC: ti_tscadc: TI Touchscreen driver updates"
> > (http://www.spinics.net/lists/linux-input/msg22107.html)
> > 
> > [2] "[PATCH v5 0/4] Support for TSC/ADC MFD driver"
> > (http://www.spinics.net/lists/linux-input/msg22832.html)
> > 
> > Patil, Rachna (8):
> >   input: TSC: ti_tscadc: Correct register usage
> >   input: TSC: ti_tscadc: Add Step configuration as platform data
> >   input: TSC: ti_tscadc: set FIFO0 threshold Interrupt
> >   input: TSC: ti_tscadc: Remove definition of End Of Interrupt register
> >   input: TSC: ti_tscadc: Rename the existing touchscreen driver
> >   MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
> >   input: TSC: ti_tsc: Convert TSC into a MFDevice
> >   IIO : ADC: tiadc: Add support of TI's ADC driver
> 
> I am fine with input portion of the patch series, please merge through MFD tree.
> 
> Thanks.
> 
> --
> Dmitry
> 

