Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0GMINq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:13:46 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:26080 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599Ab0GMINo (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Tue, 13 Jul 2010 04:13:44 -0400
Message-Id: <4C3CACD3020000230001CDCE@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 13 Jul 2010 02:13:39 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <dri-devel@lists.sourceforge.net>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

First, thank's for your kindly suggestion.

於 一，2010-07-12 於 16:19 +0100，Matthew Garrett 提到：
> 
> > On the other hand, the Poulsbo is a old and stop ship chip, do we still
> > want to add a special driver for it?
> 
> Yeah, that's my concern. There's millions of things in the wild and 
> Intel continue to refuse to take responsibility for them, so it's not 
> clear to me that it's worth putting the effort into writing a "correct" 
> driver.
> 

Yes, fully agreed! 

> > Thank's for your remind, I fully agreed cann't guarantee all poulsbo
> > systems have working acpi method. But, I am sure the MSI U110/U115 have
> > workable acpi backlight method.
> > Do you think it's good to put the special DMI detection in msi-laptop
> > driver to enable the the acpi backlight control by call
> > acpi_video_register in acpi video? But will cause msi-laptop driver
> > dependency to acpi video driver.
> 
> Mm. Well, we *know* that opregion won't work on Poulsbo as is (even 
> Intel's driver doesn't implement it), so there's no way this patch can 
> make things any worse. On the other hand, if anyone ships an OS with 
> this hack *and* a native psb driver, I'm going to look sad for some 
> time.
> 

Please then me add the MSI U110/U115 support in msi-laptop driver. I am
sure the acpi baclight method works fine on U110/U115 and I hope the
_REAL_ opensource kernel user will not have a invalid backlight control
function.

For the native psb driver, if have anyone want to ship it with newest
msi-laptop driver, then he must need take care anything in KMP, like:
disable msi-laptop or put it to modprobe blacklist.
Because the native psb driver doesn't not included in kernel mainline.

On the other hand, the Poulsbo already stop to chip, there will not have
many machine ship the native psb driver with newest msi-laptop.


Thank's a lot!
Joey Lee


