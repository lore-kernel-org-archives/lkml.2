Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab0EMXGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:06:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39504 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab0EMXGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100513224600.GB23014@suse.de>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <201005132311.26293.rjw@sisk.pl>
	 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
	 <201005132327.16163.rjw@sisk.pl>
	 <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
	 <20100513214653.GA21120@suse.de>
	 <13B9B4C6EF24D648824FF11BE896716203BB0EEAE9@dlee02.ent.ti.com>
	 <20100513224600.GB23014@suse.de>
Date: Thu, 13 May 2010 16:06:14 -0700
Message-ID: <AANLkTilL43ZG2r7kHu6B4q2aaZsiNU_24uRCutCZCGsC@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <gregkh@suse.de>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Daniel Walker <dwalker@fifo99.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       "Cousson, Benoit" <b-cousson@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 3:46 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, May 13, 2010 at 05:33:58PM -0500, Woodruff, Richard wrote:
>>
>> > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> > owner@vger.kernel.org] On Behalf Of Greg KH
>> > Sent: Thursday, May 13, 2010 4:47 PM
>>
>> > Also note that such a driver, without wakelocks, would never get tested,
>> > and so, things start quickly diverging.
>>
>> Do wakelock enabled drivers require a wakelock aware user space to
>> function properly?
>
> Not that I can tell, but others might know more.
>

Some of our drivers may not work correctly with forced suspend, but if
you don't use suspend at all, the wakelocks have no effect and all the
drivers will work correctly.

>> If the driver is added you want to make sure the benefit is there and
>> testable for all userspaces.
>
> Agreed.
>
> thanks,
>
> greg k-h
>



-- 
Arve Hjønnevåg
