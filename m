Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab0JZPuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:50:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36956 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab0JZPuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:50:14 -0400
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
Date: Tue, 26 Oct 2010 10:50:02 -0500
Subject: RE: [PATCH 8/8] staging: tidspbridge - make sync_wait_on_event
 interruptible
Thread-Topic: [PATCH 8/8] staging: tidspbridge - make sync_wait_on_event
 interruptible
Thread-Index: Act0qPq5fMCDEToSSvWkIk3VOK16+wAfA2Iw
Message-ID: <496565EC904933469F292DDA3F1663E602F49E2802@dlee06.ent.ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<1288054306-4361-2-git-send-email-x0095840@ti.com>
	<1288054306-4361-3-git-send-email-x0095840@ti.com>
	<1288054306-4361-4-git-send-email-x0095840@ti.com>
	<1288054306-4361-5-git-send-email-x0095840@ti.com>
	<1288054306-4361-6-git-send-email-x0095840@ti.com>
	<1288054306-4361-7-git-send-email-x0095840@ti.com>
	<1288054306-4361-8-git-send-email-x0095840@ti.com>
	<1288054306-4361-9-git-send-email-x0095840@ti.com>
 <AANLkTinnLb9DLMKfxEs_KqMvOmegSDYRuLWh5y=hhBCe@mail.gmail.com>
In-Reply-To: <AANLkTinnLb9DLMKfxEs_KqMvOmegSDYRuLWh5y=hhBCe@mail.gmail.com>
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
> Sent: Monday, October 25, 2010 7:59 PM
> To: Guzman Lugo, Fernando
> Cc: gregkh@suse.de; felipe.contreras@nokia.com; 
> Hiroshi.DOYU@nokia.com; linux-kernel@vger.kernel.org; 
> andy.shevchenko@gmail.com; linux-omap@vger.kernel.org; 
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 8/8] staging: tidspbridge - make 
> sync_wait_on_event interruptible
> 
> On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo 
> <x0095840@ti.com> wrote:
> > So that avoid non-killable process.
> 
> It would be useful to interrupt these tasks from user-space. 
> A separate ioctl to do that would be needed.

I don't see use case where that could be needed. It is only
To avoid a nonkillable task in the case the user pass an infinite
Timeout.

If you have some test case where that ioctl would be needed
Please share it in order to find the best solution.

Regards,
Fernando.

> 
> --
> Felipe Contreras
> 