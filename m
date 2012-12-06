Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423098Ab2LFKYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:24:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36488 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423069Ab2LFKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:24:41 -0500
Date: Thu, 6 Dec 2012 11:24:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121206102437.GB30885@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121203212047.24373.8646.stgit@grignak.americas.hpqcorp.net>
 <20121203212053.24373.10914.stgit@grignak.americas.hpqcorp.net>
 <20121204093007.GG4369@liondog.tnic>
 <1354758031.17101.7.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354758031.17101.7.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 08:40:31PM -0500, Steven Rostedt wrote:
> You can have a config that enables these trace points, and when you
> enable one of the systems that uses them, have that config select the
> config that enables tracepoints. Have that config compile the file for
> tracepoints. For example, in a Makefile:
> 
> obj-$(CONFIG_RAS_TRACE_POINTS) += ras-trace.o
> 
> 
> Use #ifdef CONFIG_FOO_BAR around tracepoints that are required for
> specific systems if the tracepoints in the header file are for different
> subsystems that can be enabled or disabled separately by configs.

Cool, this sounds exactly like what we should do, I'll hack it up soon.

Thanks a lot.

-- 
Regards/Gruss,
    Boris.
