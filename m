Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0K3AEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:04:53 -0500
Received: from smtp-out.google.com ([74.125.121.35]:5685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0K3AEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:04:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Z8wzGOZdBmMlw3b5HbsCI9HXPyn2xj9rUJLw7Vu1R3W2UCP1FA9Z58HujHJEbo1RIq
         J0o1m+bv11rH+ZqhjG5A==
Date: Mon, 29 Nov 2010 16:04:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 2/2 v2] mm: add node hotplug emulation
In-Reply-To: <20101128051749.GA11474@suse.de>
Message-ID: <alpine.DEB.2.00.1011291602560.21653@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com> <20101121173438.GA3922@suse.de> <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com> <alpine.DEB.2.00.1011211505440.30377@chino.kir.corp.google.com> <20101122005658.GA6710@suse.de>
 <alpine.DEB.2.00.1011271750140.3764@chino.kir.corp.google.com> <20101128051749.GA11474@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Greg KH wrote:

> Then name it as such, not the generic "hotplug" like you just did.
> "mem_hotplug" would make sense, right?
> 

Ok, Shaohui has taken my patches to post as part of the larger series and 
I requested that the interface be changed from s/hotplug/mem_hotplug as 
you suggested (and you should be cc'd).  I agree it's a better name to 
isolate memory hotplug debugging triggers from others.

Thanks Greg!
