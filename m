Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1BVWbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:31:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1BVWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WxpJyNrfhvILFMSM4vWmobStyikuA7/ffKChbvTVX61hNecE/RvnhMf3fsH/9qgShM
         Bp0Qk+uYnDilWL63ukhA==
Date: Tue, 22 Feb 2011 14:31:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [0/7, v9] NUMA Hotplug Emulator (v9)
In-Reply-To: <20101210073119.156388875@intel.com>
Message-ID: <alpine.DEB.2.00.1102221429030.31758@chino.kir.corp.google.com>
References: <20101210073119.156388875@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, shaohui.zheng@intel.com wrote:

> v9:
> 
> Solve the bug reported by Eric B Munson, check the return value of cpu_down when do
>  CPU release.
> 
> Solve the conflicts with Tejun Heo' Unificaton NUMA code, re-work patch 5 based on his
> patch.
> 
> Some small changes on debugfs per-node add_memory interface.
> 

Hi Shaohui,

Tejun's NUMA unification work has been merged into x86/mm, so I think it 
would possible to rebase your hotplug emulator patchset on top of it 
without too many conflicts now.

It should probably be based on x86/mm from 
http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git
