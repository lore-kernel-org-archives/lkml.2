Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0JTQEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:04:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35338 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0JTQEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:04:39 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Wed, 20 Oct 2010 21:33:43 +0530
Subject: RE: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Topic: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Index: ActwFs4ULfIcvCKCStKdC8z1qy3JmAAWXj0Q
Message-ID: <19F8576C6E063C45BE387C64729E739404AA4E7C07@dbde02.ent.ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
	<1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
 <20101019222220.892e67e4.akpm@linux-foundation.org>
In-Reply-To: <20101019222220.892e67e4.akpm@linux-foundation.org>
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
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, October 20, 2010 12:22 AM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; alan@lxorguk.ukuu.org.uk;
> devel@driverdev.osuosl.org
> Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
> 
> On Wed,  6 Oct 2010 12:18:14 -0400 pavan_savoy@ti.com wrote:
> 
> > +/**
> > + * st_reg_complete -
> > + * to call registration complete callbacks
> > + * of all protocol stack drivers
> > + */
> > +void st_reg_complete(struct st_data_s *st_gdata, char err)
> 
> The driver has a lot of "kerneldoc" comments which are incomplete -
> they don't document the arguments.

For functions too?
Sure Andrew, I will post a patch to comment the arguments soon.

Thanks for the comments.

