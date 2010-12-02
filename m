Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0LBA5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:57:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37786 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab0LBA5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:57:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=FHPK5ZawpvuQG3TYc5+cDAFl9RXrXQlUFtiOq5rnoUuNCjA5P0sX9XTxHCO+HAVV9n
         m+3pMFHcx1ensAb03Pqg==
Date: Wed, 1 Dec 2010 16:57:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
In-Reply-To: <20101130071437.461969179@intel.com>
Message-ID: <alpine.DEB.2.00.1012011656590.1896@chino.kir.corp.google.com>
References: <20101130071324.908098411@intel.com> <20101130071437.461969179@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, shaohui.zheng@intel.com wrote:

> From: Shaohui Zheng <shaohui.zheng@intel.com>
> 
> Implement a debugfs inteface /sys/kernel/debug/mem_hotplug/probe for meomory hotplug
> emulation.  it accepts the same parameters like
> /sys/devices/system/memory/probe.
> 

NACK, we don't need two interfaces to do the same thing.  
