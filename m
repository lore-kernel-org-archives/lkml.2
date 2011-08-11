Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1HKROX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:14:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4259 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HKROV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:14:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 11 Aug 2011 10:14:18 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Thu, 11 Aug 2011 10:14:17 -0700
Subject: RE: [PATCH RESEND] Input: tegra-kbc - correct call to
 input_free_device
Thread-Topic: [PATCH RESEND] Input: tegra-kbc - correct call to
 input_free_device
Thread-Index: AcxYRvIVbs1dLHOETUiVTZGkcRvzHwAAwnjQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24C2F@HQMAIL01.nvidia.com>
References: <1313052569.2139.1.camel@phoenix>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24C0A@HQMAIL01.nvidia.com>
 <20110811165134.GA24861@core.coreip.homeip.net>
In-Reply-To: <20110811165134.GA24861@core.coreip.homeip.net>
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

Dmitry Torokhov wrote at Thursday, August 11, 2011 10:52 AM:
> On Thu, Aug 11, 2011 at 09:42:54AM -0700, Stephen Warren wrote:
> > Axel Lin wrote at Thursday, August 11, 2011 2:49 AM:
> > > If kzalloc for kbc fails, then we have NULL pointer dereference while
> > > calling input_free_device(kbc->idev) in the error handling.
> > > So it is safer to always use the original name, input_dev.
> > >
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >
> > Reviewed-by: Stephen Warren <swarren@nvidia.com>
> 
> Gah, sorry, already pushed into my public branch so won't be able so
> add your reviewed-by...

No worries; you had no reason to expect anyone to review it!

-- 
nvpublic

