Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1BCVWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:22:01 -0500
Received: from mxs.selfip.ru ([77.221.143.26]:55219 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753022Ab1BCVWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:22:00 -0500
X-ACL-SPF: 
Subject: Re: [Xen-devel] [PATCH R3 0/7] xen/balloon: Memory hotplug support
 for Xen balloon driver
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20110203162345.GC1364@router-fw-old.local.net-space.pl>
References: <20110203162345.GC1364@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Fri, 04 Feb 2011 00:20:09 +0300
Message-ID: <1296768009.2346.7.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 17:23 +0100, Daniel Kiper wrote:
> Hi,
> 
> I am sending next version of memory hotplug
> support for Xen balloon driver patch. It applies
> to Linus' git tree, v2.6.38-rc3 tag. Most of
> suggestions were taken into account. Thanks for
> everybody who tested and/or sent suggestions
> to my work.
> 
> There are a few prerequisite patches which fixes
> some problems found during work on memory hotplug
> patch or add some futures which are needed by
> memory hotplug patch.
> 
> Full list of fixes/futures:
>   - mm: Add add_registered_memory() to memory hotplug API,
>   - xen/balloon: Removal of driver_pages,
>   - xen/balloon: HVM mode support,
>   - xen/balloon: Migration from mod_timer() to schedule_delayed_work(),
>   - xen/balloon: Protect against CPU exhaust by event/x process,
>   - xen/balloon: Minor notation fixes,
>   - xen/balloon: Memory hotplug support for Xen balloon driver.
> 
> Additionally, I suggest to apply patch prepared by Steffano Stabellini
> (https://lkml.org/lkml/2011/1/31/232) which fixes memory management
> issue in Xen guest. I was not able boot guest machine without
> above mentioned patch.
> 
> I have received notice that this series of patches broke
> machine migration under Xen. I am going to solve that problem ASAP.
> I do not have received any notices about other problems till now.
> 
> Daniel

Thank You very much for work. I'm try this patch for migration issues
and send comments. 
I have some may be offtopic question: Is that possible to export balloon
function balloon_set_new_target to GPL modules (EXPORT_SYMBOL_GPL) ? 
This helps to kernel modules (not in kernel tree) to contol balloonin
(for example autoballoon or something else) without needing to write so
sysfs. (Writing files from kernel module is bad, this says Linux Kernel
Faq).

