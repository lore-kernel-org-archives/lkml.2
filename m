Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KEI3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:29:41 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:41627 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2KEI3k convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 5 Nov 2012 03:29:40 -0500
Message-Id: <509786FF02000078000A6491@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Nov 2012 08:29:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233537A2A5@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537A2A5@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.11.12 at 13:16, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Konrad Rzeszutek Wilk wrote:
>>>> From f514b97628945cfac00efb0d456f133d44754c9d Mon Sep 17 00:00:00
>>>> 2001 
>>> From: Liu, Jinsong <jinsong.liu@intel.com>
>>> Date: Thu, 1 Nov 2012 21:02:36 +0800
>>> Subject: [PATCH 1/2] Xen acpi pad implement
>>> 
>>> PAD is acpi Processor Aggregator Device which provides a control
>>> point 
>>> that enables the platform to perform specific processor configuration
>>> and control that applies to all processors in the platform.
>>> 
>>> This patch is to implement Xen acpi pad logic. When running under Xen
>>> virt platform, native pad driver would not work. Instead Xen pad
>>> driver, 
>>> a self-contained and very thin logic level, would take over acpi pad
>>> staff. When acpi pad notify OSPM, xen pad logic intercept and parse
>>> _PUR object 
>>> and then hypercall to hyervisor for the rest work, say, core parking.
>> 
>> Two comments:
>>  - Did you look at the SuSE tree? Jan mentioned that they did some
>>    fixes? Did you carry them over?
> 
> I didn't look at Suse tree.
> 
> Jan, would you please tell me where can I pull Suse tree?

http://kernel.opensuse.org/git

> have you 
> implemented xen-acpi-pad logic at Suse dom0 and which points you have fixed?

Yes, we've been carrying this for quite some time. I don't recall
the specific cleanups to the code I did, so I can only refer you
to the trees above.

Jan

