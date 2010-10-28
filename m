Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0J1JVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:21:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:60581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0J1JVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:21:37 -0400
Message-ID: <4CC9409D.7050405@kernel.org>
Date: Thu, 28 Oct 2010 11:21:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Teck Choon Giam <giamteckchoon@gmail.com>
Subject: Re: Section conflicts with percpu variables
References: <4CC8780C.8090401@goop.org>
In-Reply-To: <4CC8780C.8090401@goop.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Oct 2010 09:21:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 09:05 PM, Jeremy Fitzhardinge wrote:
>  Hi Tejun,
> 
> I wonder if you could have a look at this.  I have someone reporting
> compilation failures when using the stock Centos 5 compiler:
> 
> arch/x86/xen/mmu.c:163: error: __pcpu_scope_xen_cr3 causes a section type conflict
> arch/x86/xen/mmu.c:164: error: __pcpu_scope_xen_current_cr3 causes a section type conflict
> arch/x86/xen/mmu.c:163: error: __pcpu_unique_xen_cr3 causes a section type conflict
> arch/x86/xen/mmu.c:164: error: __pcpu_unique_xen_current_cr3 causes a section type conflict
> 
> Looking at mmu.i, I can't see why it is picking on these particular
> per-cpu variables.  Do you have any insight into this.

Hmmm... me neither.  section type conflict?  Does it make any
different if you move the definitions near the top of the file or use
a different compiler version?

Thanks.

-- 
tejun
