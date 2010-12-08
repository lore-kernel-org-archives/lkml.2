Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0LHVSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:18:13 -0500
Received: from smtp-out.google.com ([74.125.121.35]:47941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab0LHVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:18:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oWgsiYuahZ2EwqBsZTw0+tsEpnBr11r/+Hm1No3ixzNa+9YAw+hCZqjqkptjjcELzm
         OLS9VgOlAfUcvkwYPTNA==
Date: Wed, 8 Dec 2010 13:18:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@linux.intel.com>
cc: Eric B Munson <emunson@mgebm.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/7,v8] NUMA Hotplug Emulator: documentation
In-Reply-To: <20101207232000.GA5353@shaohui>
Message-ID: <alpine.DEB.2.00.1012081316530.15658@chino.kir.corp.google.com>
References: <20101207010033.280301752@intel.com> <20101207010139.681125359@intel.com> <20101207182420.GA2038@mgebm.net> <20101207232000.GA5353@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Shaohui Zheng wrote:

> Eric,
> 	the major change on the patchset is on the interface, for the v8 emulator,
> we accept David's per-node debugfs add_memory interface, we already included
> in the documentation patch. the change is very small, so it is not obvious.
> 

It's still stale as Eric mentioned: for instance, the reference to 
/sys/kernel/debug/node/add_node which is now under mem_hotplug.  There may 
be other examples as well.
