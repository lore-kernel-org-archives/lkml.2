Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0HRRLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:11:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34101 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0HRRLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:11:34 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Aug 2010 22:41:24 +0530
Subject: RE: patch "Staging: ti-st: update TODO" added to staging-next tree
Thread-Topic: patch "Staging: ti-st: update TODO" added to staging-next tree
Thread-Index: Acsz6DYDEFq8vHO1THeraMPtcnLT1QLD+D+Q
Message-ID: <19F8576C6E063C45BE387C64729E7394044F124C7D@dbde02.ent.ti.com>
References: <1280799040524@site>
 <19F8576C6E063C45BE387C64729E7394044EF4CBB2@dbde02.ent.ti.com>
 <20100804151722.GA26777@suse.de>
In-Reply-To: <20100804151722.GA26777@suse.de>
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

Greg,

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, August 04, 2010 10:17 AM
> To: Savoy, Pavan
> Subject: Re: patch "Staging: ti-st: update TODO" added to staging-next tree
> 
> On Wed, Aug 04, 2010 at 06:40:25PM +0530, Savoy, Pavan wrote:
> >
> >
> >
> >
> >
> > > -----Original Message-----
> > > From: gregkh@suse.de [mailto:gregkh@suse.de]
> > > Sent: Monday, August 02, 2010 8:31 PM
> > > To: Savoy, Pavan; gregkh@suse.de
> > > Subject: patch "Staging: ti-st: update TODO" added to staging-next tree
> >
> > Greg,
> >
> > Please review the code and suggest as to what needs to be done to move it
> out of staging...
> 
> Please remind me after the merge window is over, as I have a lot of work
> to do the next 2 weeks handling that.

With 2.6.36-rc1 out, Please review the driver, and suggest what could be done to move it out of staging?
I would need the headers (st.h) to be in generic places to introduce FM-V4L2 driver which uses ST.


> thanks,
> 
> greg k-h
