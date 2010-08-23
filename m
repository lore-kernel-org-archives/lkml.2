Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0HWKfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:35:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51496 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0HWKfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:35:10 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "byron.bbradley@gmail.com" <byron.bbradley@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 23 Aug 2010 16:04:19 +0530
Subject: RE: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
Thread-Topic: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
Thread-Index: ActCjLDP5hpbcTeNRce4Z3RMqyggZgAIPRXQ
Message-ID: <19F8576C6E063C45BE387C64729E7394044F12543F@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1282393829-7326-2-git-send-email-hvaibhav@ti.com>
 <20100821140541.GA31697@nokia.com>
 <19F8576C6E063C45BE387C64729E7394044F1252C6@dbde02.ent.ti.com>
 <20100823062957.GA1068@nokia.com>
In-Reply-To: <20100823062957.GA1068@nokia.com>
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
> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
> Sent: Monday, August 23, 2010 12:00 PM
> To: Hiremath, Vaibhav
> Cc: Balbi Felipe (Nokia-MS/Helsinki); linux-kernel@vger.kernel.org;
> akpm@linux-foundation.org; byron.bbradley@gmail.com; linux-
> omap@vger.kernel.org
> Subject: Re: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
> 
> Hi,
> 
> please break your lines at 80-characters. 

Normally I do take care of this, but missed this time. I will be more careful in the future.

> Also the [Hiremath, Vaibhav]
> is unnecessary.
> 
> On Mon, Aug 23, 2010 at 06:58:42AM +0200, ext Hiremath, Vaibhav wrote:
> >> don't you need some locking on the irq handler ? a mutex maybe ? Just
> >> wondering...
> >>
> >[Hiremath, Vaibhav] Yes definitely we do need locking here, I thought
> >of adding locking mechanism in subsequent patch, does it makes sense?
> 
> so you add a buggy patch and fix it later ? If you already know it's
> buggy, why not changing the patch that adds the bug ?
> 
[Hiremath, Vaibhav] Nothing to argue here, I have to admit/accept and fix this.

Thanks,
Vaibhav

> --
> balbi
> 
> DefectiveByDesign.org
