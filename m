Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0LTN5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:57:47 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:30510 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab0LTN5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:57:46 -0500
Date: Mon, 20 Dec 2010 14:57:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mikael =?ISO-8859-1?B?U3Ry9m0=?= <mikael@sesamiq.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Julien BLACHE <jb@jblache.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than 
 hardcoding resources and devices
Message-ID: <20101220145721.4c58ff3e@endymion.delvare>
In-Reply-To: <1292852674.2118.10.camel@mike-laptop>
References: <20101217221618.GA13207@ericsson.com>
	<1292624661-32474-1-git-send-email-mjg@redhat.com>
	<20101218042320.GA14104@ericsson.com>
	<20101218093719.GA1493@polaris.bitmath.org>
	<20101218110954.7a2ca190@endymion.delvare>
	<20101218103139.GA1668@polaris.bitmath.org>
	<878vzngvyn.fsf@sonic.technologeek.org>
	<20101218115742.GA2063@polaris.bitmath.org>
	<1292852674.2118.10.camel@mike-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 21:44:34 +0800, Mikael Ström wrote:
> Hi,
> 
> I know nothing about the background to the mail below, but if it's of
> any help, macfanctld uses the following hardwired paths,
> 
> reading:
> 
> /sys/devices/platform/applesmc.768/temp<n>_input
> 
> and writing:
> 
> /sys/devices/platform/applesmc.768/fan1_min
> /sys/devices/platform/applesmc.768/fan2_min
> /sys/devices/platform/applesmc.768/fan1_manual
> /sys/devices/platform/applesmc.768/fan2_manual
> 
> If any of those are to be broken, please advice in advance so i can
> update the source before you break it, avoiding that the users fry their
> MacBooks.

I would expect the kernel driver to behave sanely in the absence of a
user-space application. Isn't it the case? If not, I consider it a
serious bug in the driver, which should be addressed ASAP.

-- 
Jean Delvare
