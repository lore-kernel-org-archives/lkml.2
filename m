Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab0EFQtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:49:43 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:63938 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0EFQtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:49:42 -0400
Message-id: <4BE2F31E.5020201@acm.org>
Date: Thu, 06 May 2010 11:49:34 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>, Myron Stowe <myron.stowe@hp.com>
Subject: Re: [PATCH 1/8] ipmi: Change addr_source to an enum rather than strings
References: <20100503133331.GA8130@minyard.local>
 <20100504155356.57722519.akpm@linux-foundation.org>
In-reply-to: <20100504155356.57722519.akpm@linux-foundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I already have three IPMI patches queued:
>
> http://userweb.kernel.org/~akpm/mmotm/broken-out/ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
>   
I don't believe this patch is valid.  The discovery order in the patch 
from Matthew is the correct one, I believe.  So NACK on this one.

> http://userweb.kernel.org/~akpm/mmotm/broken-out/ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch
>   
This should be good.

> http://userweb.kernel.org/~akpm/mmotm/broken-out/ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch
>   
This is nice, I'll rework it and resend.

Thanks a bunch.

-corey

> The first two were repairable.  The third is now thoroughly trashed and
> needs redoing.
>
> I have no record of you having reviewed or [n]acked those three IPMI
> patches?
>
>   

