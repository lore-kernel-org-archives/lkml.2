Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2GQJdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:33:10 -0400
Received: from ozlabs.org ([203.10.76.45]:56681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab2GQJdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:33:06 -0400
To: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [RFC/PATCH] Use kernel supplied MMU info for kvm tool
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jul 2012 10:33:05 +0100
From: Matt Evans <matt@ozlabs.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <penberg@kernel.org>, <kvm-ppc@vger.kernel.org>,
        <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Message-ID: <3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>
User-Agent: Roundcube Webmail/0.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 2012-07-17 06:00, Michael Ellerman wrote:

> This is a series for kvmtool that uses a newish kernel API to get
> MMU info, which is then fed to the guest.
>
> Currently we just make a good guess based on the PVR, but that is
> potentially flakey in a few ways. The most notable is that if you 
> don't
> specify hugepages we don't boot - because the guest is told we 
> support
> 16M pages, but we don't really (on HV).

Just had a look, all good.  Thanks for tidying some old FIXMEs, 
especially the page/segment DT props encoding grot -- and the designated 
inits in the cpuinfo struct, whew, I heard the scream on IRC.  Sorry. 
;-)


Acked-by: Matt Evans <matt@ozlabs.org>


Matt

