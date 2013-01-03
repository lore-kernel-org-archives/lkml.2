Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3ACWjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:39:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3ACWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:39:15 -0500
Date: Thu, 3 Jan 2013 14:39:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/4 v5 RESEND] rtc: add rtc-driver for HID sensors of
 type time
Message-Id: <20130103143913.16d4e867.akpm@linux-foundation.org>
In-Reply-To: <1355575537-10093-3-git-send-email-holler@ahsoftware.de>
References: <50CC6FE3.6060705@ahsoftware.de>
	<1355575537-10093-1-git-send-email-holler@ahsoftware.de>
	<1355575537-10093-3-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2012 13:45:36 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> This driver makes the time from HID sensors (hubs) which are offering
> such available like any other RTC does.
> 
> It is necessary that all values like year, month etc, are send as
> 8bit values (1 byte each) and all of them in 1 report. Also the
> spec HUTRR39b doesn't define the range of the year field, we
> tread it as 0 - 99 because that's what most RTCs I know about are
> offering.
> 
> Currently the time can only be read. Setting the time must be done
> through sending a report (or a feature). The spec currently doesn't
> define how and I'm not sure if I just should define something by myself.
> 

Looks OK to me.  It sounds like Jonathan will be merging these patches
when he's happy with them - please do proceed that way.

