Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2BWOyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:54:10 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:35461 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2BWOyI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Thu, 23 Feb 2012 09:54:08 -0500
Message-Id: <4F46530B020000780007F751@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 23 Feb 2012 14:54:03 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <jinsong.liu@intel.com>, <konrad.wilk@oracle.com>
Cc: <keir.xen@gmail.com>, <len.brown@intel.com>, <shaohua.li@intel.com>,
        <lenb@kernel.org>, <xen-devel@lists.xensource.com>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Liu, Jinsong" <jinsong.liu@intel.com> 02/23/12 2:29 PM >>>
>--- a/drivers/acpi/Kconfig
>+++ b/drivers/acpi/Kconfig
>@@ -213,10 +213,11 @@ config ACPI_HOTPLUG_CPU
>    default y
 >
>config ACPI_PROCESSOR_AGGREGATOR
>-    tristate "Processor Aggregator"
>+    bool "Processor Aggregator"

There must be ways to address whatever strange problem you see without
making this piece of code non-modular.

>    depends on ACPI_PROCESSOR
>    depends on EXPERIMENTAL
>    depends on X86
>+    default n

This is pointless.

>    help
>      ACPI 4.0 defines processor Aggregator, which enables OS to perform
>      specific processor configuration and control that applies to all

Jan

