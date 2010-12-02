Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0LBA73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:59:29 -0500
Received: from smtp-out.google.com ([74.125.121.35]:17635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab0LBA73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:59:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=w7d+1Enw9+t6MJQlLrr2idthP1xyP9LFM2qqN5kPBpDz21P1yiqXCCKGKtQ8vBRdC4
         NnUNq4nsNT+EyJZ0xmpA==
Date: Wed, 1 Dec 2010 16:59:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v5] NUMA Hotplug Emulator: Add node hotplug emulation
In-Reply-To: <20101130231613.GA9117@shaohui>
Message-ID: <alpine.DEB.2.00.1012011658540.1896@chino.kir.corp.google.com>
References: <20101129091750.950277284@intel.com> <20101129091935.703824659@intel.com> <alpine.DEB.2.00.1011291600020.21653@chino.kir.corp.google.com> <20101130012205.GB3021@shaohui> <alpine.DEB.2.00.1011301208060.12979@chino.kir.corp.google.com>
 <20101130231613.GA9117@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Shaohui Zheng wrote:

> David,
> 	we provide both debugfs and sysfs interface for memory probe, the sysfs 
> interface is always available. For debugfs interface, it depends on CONFIG_DEBUG_FS.
> 	we can also think that memory hotplug emulation _is_ a debuging function,
> so we accept Dave's suggestion to provide debugfs interface.
> 

We don't need two different interfaces, one in sysfs and one in debugfs, 
to hotplug memory.
