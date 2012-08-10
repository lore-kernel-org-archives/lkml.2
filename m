Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2HJPsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 11:48:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57828 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2HJPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 11:48:18 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 10 Aug 2012 08:48:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [lm-sensors] NULL dereference BUG in sch56xx_init()
Message-ID: <20120810154815.GA29281@roeck-us.net>
References: <20120809125526.GA11926@localhost>
 <20120809144239.GA6604@roeck-us.net>
 <5024C7EF.7090408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5024C7EF.7090408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 10:35:59AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/09/2012 04:42 PM, Guenter Roeck wrote:
> >On Thu, Aug 09, 2012 at 08:55:26PM +0800, Fengguang Wu wrote:
> >>Hi Guenter,
> >>
> >>This commit triggered an oops which can be fixed by the attached diff.
> >>Should it be folded into the original one (preferable for me), or be
> >>resent as a standalone patch?
> >>
> >I folded it into the original commit.
> >
> >Thanks a lot for the test and feedback!
> 
> Fengguang, good catch, thanks!
> 
> Guenter, 2 remarks:
> 
> 1) The changing of the type of the address parameter of sch56xx_device_add is
>    not necessary

Yes, I know. I took it in anyway because it reduces code size by another 8
bytes.

> 2) A similar change is needed for the f71882fg, there the type of the address
>    variable in f71882fg_init() needs to be changed to int too.
> 
Noticed, and fixed. I merged the fix for both into the original patched for
simplicity.

Thanks,
Guenter
