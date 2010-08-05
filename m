Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab0HEIsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:48:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:21032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760001Ab0HEIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,320,1278313200"; 
   d="scan'208";a="593163570"
Subject: Re: [PATCH 4/4] ACPI, APEI, ERST debug support
From: Huang Ying <ying.huang@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <201008051027.37573.trenn@suse.de>
References: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
	 <1280735305-15379-5-git-send-email-ying.huang@intel.com>
	 <201008051027.37573.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 16:48:33 +0800
Message-ID: <1280998113.2744.83.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 16:27 +0800, Thomas Renninger wrote:
> On Monday 02 August 2010 09:48:25 Huang Ying wrote:
> > This patch adds debugging/testing support to ERST. A misc device is
> > implemented to export raw ERST read/write/clear etc operations to user
> > space. With this patch, we can add ERST testing support to
> > linuxfirmwarekit ISO (linuxfirmwarekit.org) to verify the kernel
> > support and the firmware implementation.
> 
> Shouldn't this show up in debugfs?

We do not do that because we want to export some "raw" operations of
ERST to user space, and using the interface in some automated testing
program in linuxfirmwarekit. That is, this is a interface mostly for
machine but human.

Best Regards,
Huang Ying


