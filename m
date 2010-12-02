Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0LBBGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:06:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43375 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0LBBGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XnouoGT2HpMoH1rsGduJLri5pF4GJgTPE6xjVfgz4adzMWCqY9nmuzFgWHl3jjZekT
         HHbd3Y+P2DS55YSNvnyQ==
Date: Wed, 1 Dec 2010 17:06:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v6] NUMA Hotplug Emulator: Add numa=possible option
In-Reply-To: <20101130071436.836186525@intel.com>
Message-ID: <alpine.DEB.2.00.1012011705280.6088@chino.kir.corp.google.com>
References: <20101130071324.908098411@intel.com> <20101130071436.836186525@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, shaohui.zheng@intel.com wrote:

> From:  David Rientjes <rientjes@google.com>
> 
> Adds a numa=possible=<N> command line option to set an additional N nodes
> as being possible for memory hotplug.  This set of possible nodes
> controls nr_node_ids and the sizes of several dynamically allocated node
> arrays.
> 
> This allows memory hotplug to create new nodes for newly added memory
> rather than binding it to existing nodes.
> 
> The first use-case for this will be node hotplug emulation which will use
> these possible nodes to create new nodes to test the memory hotplug
> callbacks and surrounding memory hotplug code.
> 
> CC: Shaohui Zheng <shaohui.zheng@intel.com>
> CC: Haicheng Li <haicheng.li@intel.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

You're going to need to add your Signed-off-by line immediately after mine 
if you're pushing these to a maintainer, you're along the submission 
chain.
