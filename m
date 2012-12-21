Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab2LUXlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:41:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47794 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2LUXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:41:07 -0500
Date: Fri, 21 Dec 2012 18:40:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/13] x86, 64bit: Set extra ident mapping for whole
 kernel range
Message-ID: <20121221234046.GB2000@phenom.dumpdata.com>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
 <1354089042-10023-4-git-send-email-yinghai@kernel.org>
 <20121221222840.GB1102@phenom.dumpdata.com>
 <CAE9FiQWXz1xtgbAocvgXKigKJS1Yqr_CPdiLm4N6=PrUxkoPMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWXz1xtgbAocvgXKigKJS1Yqr_CPdiLm4N6=PrUxkoPMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 02:35:25PM -0800, Yinghai Lu wrote:
> On Fri, Dec 21, 2012 at 2:28 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > Perhaps 'spare_directory' ? Or 'spare_table' ?
> 
> we have evolved -v7 and -v8 that is using FANCY/FUNNY patch of #PF
> handler set page table from HPA.
> 

Ah, that is what I get from just now plowing through my mailbox.

I did check:
ommit 103d8b76616c23ccee978d00d87d55f201d2be71
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Thu Dec 20 16:19:23 2012 -0800

    x86: Merge early kernel reserve for 32bit and 64bit

which booted fine under dom0 and domU (5GB).

> Please do check if -v7 and -v8 break xen again. (it should not !, but
> i only test dom0 once)
> 
> stop #PF handler after init_mem_mapping
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-boot-v7
> 
> stop #PF handler in x86_64_start_kernel, to keep kgdb working.
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-boot-v8

Ok, perhaps I will do that after the holidays.
> 
> Thanks
> 
> Yinghai
