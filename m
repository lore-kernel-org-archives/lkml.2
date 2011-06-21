Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1FUU12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:27:28 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:43010 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756736Ab1FUU1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:27:24 -0400
From: Kevin Hilman <khilman@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gadiyar@ti.com, parthab@india.ti.com
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver initialization
Organization: Texas Instruments, Inc.
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
	<20110620132626.GJ22420@sortiz-mobl>
	<20110620132851.GJ14262@legolas.emea.dhcp.ti.com>
	<20110620145941.GQ22420@sortiz-mobl> <87liww6tva.fsf@ti.com>
	<20110621175359.GA22420@sortiz-mobl>
Date: Tue, 21 Jun 2011 13:27:20 -0700
In-Reply-To: <20110621175359.GA22420@sortiz-mobl> (Samuel Ortiz's message of
	"Tue, 21 Jun 2011 19:53:59 +0200")
Message-ID: <87y60vrkuv.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Ortiz <sameo@linux.intel.com> writes:

> Hi Kevin,
>
> On Mon, Jun 20, 2011 at 03:06:01PM -0700, Kevin Hilman wrote:
>> Samuel Ortiz <sameo@linux.intel.com> writes:
>> 
>> > Hi Felipe,
>> >
>> > On Mon, Jun 20, 2011 at 04:28:52PM +0300, Felipe Balbi wrote:
>> >> Hi,
>> >> 
>> >> On Mon, Jun 20, 2011 at 03:26:26PM +0200, Samuel Ortiz wrote:
>> >> > On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
>> >> > > From: Keshava Munegowda <Keshava_mgowda@ti.com>
>> >> > > 
>> >> > > Oops are produced during initialization of ehci and ohci
>> >> > > drivers. This is because the run time pm apis are used by
>> >> > > the driver but the corresponding hwmod structures and
>> >> > > initialization is not merged. 
>> >> > You mean they're currently checked in a different tree ? Is that a
>> >> > public one?
>> >> 
>> >> it was supposed to go via linux-omap tree but the patches got lost in
>> >> the limbo :-(
>> > Then shouldn't those patches be the ones to be sent to Linus as a fix for 3.0 ?
>> 
>> If they were ready, maybe.  But those patches still need important work
>> (and review) and are not "fix" material but need to wait until the next
>> merge window.
> Fair enough.
>
>  
>> Basically, the original patch should not have been submitted to mainline
>> until the runtime PM support was ready, so the correct short term fix is
>> to simply revert.
>>
>> Also, to echo the question from Dima Zavin:
>> 
>> Why isn't this just a simple revert of the original patch?
> I did a revert in my tree.

Great, that's the cleanest solution IMO.  Thanks!

Kevin
