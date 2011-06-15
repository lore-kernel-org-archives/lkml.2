Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1FOPhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:37:32 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51195 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878Ab1FOPhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:37:31 -0400
From: Kevin Hilman <khilman@ti.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCHv5 2/7] HSI: omap_ssi: Introducing OMAP SSI driver
Organization: Texas Instruments, Inc.
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	<1307713124-3946-3-git-send-email-carlos.chinea@nokia.com>
	<874o3tmqhk.fsf@ti.com> <1308053544.2819.38115.camel@groo>
Date: Wed, 15 Jun 2011 08:37:26 -0700
In-Reply-To: <1308053544.2819.38115.camel@groo> (Carlos Chinea's message of
	"Tue, 14 Jun 2011 15:12:24 +0300")
Message-ID: <87zkljds21.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Chinea <carlos.chinea@nokia.com> writes:

> On Mon, 2011-06-13 at 13:21 -0700, ext Kevin Hilman wrote:
>> Carlos Chinea <carlos.chinea@nokia.com> writes:
>> 

[...]

>> > + * Copyright (C) 2010 Nokia Corporation. All rights reserved.
>> > + *
>> > + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> > + * modify it under the terms of the GNU General Public License
>> > + * version 2 as published by the Free Software Foundation.
>> > + *
>> > + * This program is distributed in the hope that it will be useful, but
>> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> > + * General Public License for more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public License
>> > + * along with this program; if not, write to the Free Software
>> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> > + * 02110-1301 USA
>> > + */
> -- cut --
>
>> > +static struct platform_device ssi_pdev = {
>> > +	.name		= "omap_ssi",
>> > +	.id		= 0,
>> > +	.num_resources	= ARRAY_SIZE(ssi_resources),
>> > +	.resource	= ssi_resources,
>> > +	.dev		= {
>> > +				.platform_data	= &ssi_pdata,
>> > +	},
>> > +};
>> 
>> omap_hwmod has all the base address and IRQ data, will construct the
>> struct resources and the platform_devices for you.  Please use
>> omap_hwmod + omap_device for this part of the code.
>> 
>
> Yes, it  is already in my TODO list ;)
>

Great.  Just so you know, we are not taking new OMAP drivers unless they
are using omap_hwmod + omap_device to create the devices.

Kevin
