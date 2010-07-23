Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0GWGFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 02:05:14 -0400
Received: from claw.goop.org ([74.207.240.146]:34272 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab0GWGFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 02:05:11 -0400
Message-ID: <4C493116.1040107@goop.org>
Date: Thu, 22 Jul 2010 23:05:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the xen tree
References: <20100723140107.2883b2d3.sfr@canb.auug.org.au>
In-Reply-To: <20100723140107.2883b2d3.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 09:01 PM, Stephen Rothwell wrote:
> arch/x86/xen/enlighten.c:71: error: __pcpu_scope_xen_vcpu causes a section type conflict
> arch/x86/xen/enlighten.c:72: error: __pcpu_scope_xen_vcpu_info causes a section type conflict
> arch/x86/xen/enlighten.c:71: error: __pcpu_unique_xen_vcpu causes a section type conflict
> arch/x86/xen/enlighten.c:72: error: __pcpu_unique_xen_vcpu_info causes a section type conflict
> arch/x86/xen/enlighten.c:558: error: __pcpu_unique_idt_desc causes a section type conflict
> arch/x86/xen/enlighten.c:760: error: __pcpu_unique_xen_cr0_value causes a section type conflict
>
> Not sure what has caused this.  I have dropped the xen tree for today.
>
> gcc version 4.4.4 binutils version 2.20.1.
>   

I've updated upstream/xen with the patch I just posted to fix this problem.

Thanks,
    J

