Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab0JZPwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:52:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42593 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab0JZPwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:52:40 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 26 Oct 2010 10:52:27 -0500
Subject: RE: [PATCH 1/8] staging: tidspbridge - remove req_addr from proc_map
Thread-Topic: [PATCH 1/8] staging: tidspbridge - remove req_addr from
 proc_map
Thread-Index: Act1A2YTPPhiIHchQnmfRyd0mA8KcAAIhGuQ
Message-ID: <496565EC904933469F292DDA3F1663E602F49E280A@dlee06.ent.ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<1288054306-4361-2-git-send-email-x0095840@ti.com>
 <AANLkTimCDM_nruvh_gqxxy0CVnw2sH5UYNT9VgyeBfZN@mail.gmail.com>
In-Reply-To: <AANLkTimCDM_nruvh_gqxxy0CVnw2sH5UYNT9VgyeBfZN@mail.gmail.com>
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
> From: Felipe Contreras [mailto:felipe.contreras@gmail.com] 
> Sent: Tuesday, October 26, 2010 6:46 AM
> To: Guzman Lugo, Fernando
> Cc: gregkh@suse.de; felipe.contreras@nokia.com; 
> Hiroshi.DOYU@nokia.com; linux-kernel@vger.kernel.org; 
> andy.shevchenko@gmail.com; linux-omap@vger.kernel.org; 
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 1/8] staging: tidspbridge - remove 
> req_addr from proc_map
> 
> On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo 
> <x0095840@ti.com> wrote:
> > The device address is assigned by tidspbridge no need for 
> that parameter anymore.
> >
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> 
> This would break the API with user-space, right?

Yes, user-space needs to be changed accordingly.

> 
> I think this change should be delayed, preferably after we 
> have a working tidspbridge.

The issue you were seeing must be fixed with patch 2/8, and
Having all the dependencies tidspbridge has to be working
Properly.

Regards,
Fernando.

> 
> --
> Felipe Contreras
> 