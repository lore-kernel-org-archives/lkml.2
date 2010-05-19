Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0ESMIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:08:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:55781 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0ESMIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,263,1272870000"; 
   d="scan'208";a="622960239"
Date: Wed, 19 May 2010 20:08:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, mem-hotplug: separate x86_64
 vmalloc_sync_all() into separate functions
Message-ID: <20100519120825.GA23778@localhost>
References: <4BF3D100.9040502@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF3D100.9040502@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No behavior change here.
> 
> Move some of vmalloc_sync_all() code into a new function
> sync_global_pgds() that will be useful for memory hotplug.

This is a neat change, thank you!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
