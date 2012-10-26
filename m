Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2JZMCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:02:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53726 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2JZMCI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 26 Oct 2012 08:02:08 -0400
Message-Id: <508A89CB020000780008E6ED@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 26 Oct 2012 13:02:03 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <jinsong.liu@intel.com>
Cc: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Liu, Jinsong" <jinsong.liu@intel.com> 10/26/12 8:18 AM >>>
>> +static struct acpi_driver xen_acpi_pad_driver = {
>> +    .name = "processor_aggregator",
>> +    .class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
>> +    .ids = pad_device_ids,
>> +    .ops = {
>> +        .add = xen_acpi_pad_add,
>
>.remove?
>
>[Jinsong] .remove method not used by any logic now (any possible point use it?), so we remove it from our former patch.

Unless there is technical difficulty implementing it, I wouldn't defer adding that code until the point where something doesn't work anymore.

>Overall I'd recommend taking a look at the cleaned up driver in
>our kernels.
>
>[Jinsong] What's your point here?

There's quite a bit of cleanup/simplification potential here, and rather than pointing the pieces out individually I would think comparing with what we have in production use might be worthwhile. But that's up to you of course.

Jan

