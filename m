Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1BDJL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:11:29 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36081 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab1BDJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:11:26 -0500
X-IronPort-AV: E=Sophos;i="4.60,425,1291611600"; 
   d="scan'208";a="134230685"
Subject: Re: [Xen-devel] [PATCH R3 0/7] xen/balloon: Memory hotplug support
 for Xen balloon driver
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>
CC: Daniel Kiper <dkiper@net-space.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1296768009.2346.7.camel@mobile>
References: <20110203162345.GC1364@router-fw-old.local.net-space.pl>
	 <1296768009.2346.7.camel@mobile>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 4 Feb 2011 09:11:22 +0000
Message-ID: <1296810682.13091.571.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 21:20 +0000, Vasiliy G Tolstov wrote:
> I have some may be offtopic question: Is that possible to export balloon
> function balloon_set_new_target to GPL modules (EXPORT_SYMBOL_GPL) ? 
> This helps to kernel modules (not in kernel tree) to contol balloonin
> (for example autoballoon or something else) without needing to write so
> sysfs. (Writing files from kernel module is bad, this says Linux Kernel
> Faq).

Is there a reason to do it from kernel space in the first place? auto
ballooning can be done by a userspace daemon, can't it?

Ian.

