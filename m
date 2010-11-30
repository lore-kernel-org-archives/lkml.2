Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0K3ABY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:01:24 -0500
Received: from smtp-out.google.com ([74.125.121.35]:4115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0K3ABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:01:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GxIG+jAWzdNLVOH9b9kyb4b0aVlOy9MbN0xMhu29sCFdzUy8Yhz1sctvfudVZpO213
         d22sFAMcqm6WwSKvtVHg==
Date: Mon, 29 Nov 2010 16:01:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v5] NUMA Hotplug Emulator: Add node hotplug emulation
In-Reply-To: <20101129091935.703824659@intel.com>
Message-ID: <alpine.DEB.2.00.1011291600020.21653@chino.kir.corp.google.com>
References: <20101129091750.950277284@intel.com> <20101129091935.703824659@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, shaohui.zheng@intel.com wrote:

> From: David Rientjes <rientjes@google.com>
> 
> Add an interface to allow new nodes to be added when performing memory
> hot-add.  This provides a convenient interface to test memory hotplug
> notifier callbacks and surrounding hotplug code when new nodes are
> onlined without actually having a machine with such hotpluggable SRAT
> entries.
> 
> This adds a new debugfs interface at /sys/kernel/debug/hotplug/add_node
> that behaves in a similar way to the memory hot-add "probe" interface.
> Its format is size@start, where "size" is the size of the new node to be
> added and "start" is the physical address of the new memory.
> 

Looks like you've changed some of the references in my changlog to 
node/add_node, but not others, such as the above.  I'd actually much 
rather prefer to take Greg's latest suggestion of doing 
s/hotplug/mem_hotplug instead.

Would it be possible to repost the patch with that change?

Thanks!
