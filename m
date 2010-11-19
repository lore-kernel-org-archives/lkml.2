Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0KSQgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:36:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58974 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0KSQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:36:21 -0500
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20101119075119.GD3327@shaohui>
References: <20101117020759.016741414@intel.com>
	 <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz>
	 <20101119075119.GD3327@shaohui>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 19 Nov 2010 08:36:09 -0800
Message-ID: <1290184569.32329.1986.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 15:51 +0800, Shaohui Zheng wrote:
> the purpose of hotplug emulator is providing a possible solution for cpu/memory
> hotplug testing, the interface upgrading is not part of emulator. Let's forget
> configfs here. 

If it's just for testing, you're right, we probably shouldn't go to the
trouble of making a new interface.  At the same time, we shouldn't put
something in /sys or configfs that we're not committed to, long-term.

So, not to replace the memory probe file, but _only_ to drive the new
debug-only node hot-add, I think its appropriate place is debugfs.

-- Dave

