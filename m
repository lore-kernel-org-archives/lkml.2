Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2KPVcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:32:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:35458 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab2KPVcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:32:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="220829646"
Message-ID: <50A6B0E6.2010608@linux.intel.com>
Date: Fri, 16 Nov 2012 13:32:22 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, mchehab@redhat.com
Subject: Re: Wrong defaults in 3.7-rc3
References: <20121115110620.GA3451@elf.ucw.cz>
In-Reply-To: <20121115110620.GA3451@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 03:06 AM, Pavel Machek wrote:
> Hi!
> 
> Supervisor Mode Access Prevention (X86_SMAP) [Y/n/?] (NEW)
> 
> ...Slows stuff down, eats memory, only works on unreleased Intel CPUs
> (from 2013!)  perhaps should be off by default?
> 
> "Supervisor Mode Access Prevention (SMAP) is a security
> feature in newer Intel processors.  There is a small
> performance cost if this enabled and turned on; there is
> also a small increase in the kernel size if this is enabled."
> 

*Extremely* small.  Unless you are targeting a specific processor there
is no point in disabling it.  If anyone can find a non-SMAP processor on
which the overhead is measurable I would be highly surprised, except
perhaps some embedded 486 clone.

	-hpa


