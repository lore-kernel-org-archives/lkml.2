Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0LAATM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:19:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab0LAATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NRb4WmXy1zyHk4Hi/1bscSeWT4CnDLuf8qjOtAzAtH5DqpIn3BpAJR8nn/LtTUP2J2
         jWPcygnzfJWqMiDjQt7Q==
Date: Tue, 30 Nov 2010 16:19:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8, v6] NUMA Hotplug Emulator: documentation
In-Reply-To: <20101130071436.732999291@intel.com>
Message-ID: <alpine.DEB.2.00.1011301618440.18341@chino.kir.corp.google.com>
References: <20101130071324.908098411@intel.com> <20101130071436.732999291@intel.com>
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
> add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
> to explain the usage for the hotplug emulator.
> 
> Reviewed-By: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Haicheng Li <haicheng.li@intel.com>
> Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>

Signed-off-by: David Rientjes <rientjes@google.com>
