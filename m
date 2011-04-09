Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1DIG0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 02:26:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55737 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1DIG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 02:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110409021654.GA4408@suse.de>
References: <20110408004007.GC3923@sortiz-mobl> <20110407193855.1e9182bb@debxo>
 <20110408231108.GD30969@sortiz-mobl> <20110409021654.GA4408@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Apr 2011 23:26:26 -0700
X-Google-Sender-Auth: lS0j-7CVtVhEOCWBQkCdKIx5SxU
Message-ID: <BANLkTimUobq1KCYKKYQ_CB69fYMTF3bYQQ@mail.gmail.com>
Subject: Re: [PATCH v1] mfd: Fetch cell pointer from platform_device->mfd_cell
To: Greg KH <gregkh@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 7:16 PM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Apr 09, 2011 at 01:11:09AM +0200, Samuel Ortiz wrote:
>>
>> In order for MFD drivers to fetch their cell pointer but also their
>> platform data one, an mfd cell pointer is added to the platform_device
>> structure.
>> That allows all MFD sub devices drivers to be MFD agnostic, unless
>> they really need to access their MFD cell data. Most of them don't,
>> especially the ones for IPs used by both MFD and non MFD SoCs.
>>
>> Cc: Greg KH <gregkh@suse.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> I'm guesing this will go through someone elses tree than mine?

I'd say so.  Samuel, please get this out to Linus,

thanks,
g.
