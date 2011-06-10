Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab1FJOTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:19:01 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:59364 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab1FJOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:18:59 -0400
Message-ID: <4DF227CF.4080807@tilera.com>
Date: Fri, 10 Jun 2011 10:18:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        <lethal@linux-sh.org>, <davem@davemloft.net>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <damm@opensource.se>,
        <arnd@arndb.de>, <hans.rosenfeld@amd.com>, <len.brown@intel.com>,
        <borislav.petkov@amd.com>, <tj@kernel.org>
Subject: Re: [PATCH v3] cpuinfo_op: consolidate extern declaration
References: <201106081559.42931.hartleys@visionengravers.com>
In-Reply-To: <201106081559.42931.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/2011 6:59 PM, H Hartley Sweeten wrote:
> All the architectures supported by the kernel also support
> /proc/cpuinfo. Only a couple actually declare the seq_operations
> as extern. All the others will produce a sparse warning like:
>
> warning: symbol 'cpuinfo_op' was not declared. Should it be static?
>
> Fix all the warnings and consolidate the declaration by putting it
> in <linux/seq_file.h>.
>
> [...]
> --- a/arch/tile/include/asm/processor.h
> +++ b/arch/tile/include/asm/processor.h

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


