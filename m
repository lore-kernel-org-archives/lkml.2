Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0KYHSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:18:14 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46831 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab0KYHSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:18:13 -0500
Subject: Re: [PATCH 2/5] MIPS/Perf-events: Work with the new PMU interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, fweisbec@gmail.com, will.deacon@arm.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290063401-25440-3-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-3-git-send-email-dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 08:01:09 +0100
Message-ID: <1290668469.2072.550.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 14:56 +0800, Deng-Cheng Zhu wrote:
> 
> This is the MIPS part of the following commits by Peter Zijlstra:
> 
> a4eaf7f14675cb512d69f0c928055e73d0c6d252
>         perf: Rework the PMU methods
> 33696fc0d141bbbcb12f75b69608ea83282e3117
>         perf: Per PMU disable
> 24cd7f54a0d47e1d5b3de29e2456bfbd2d8447b7
>         perf: Reduce perf_disable() usage
> b0a873ebbf87bf38bf70b5e39a7cadc96099fa13
>         perf: Register PMU implementations
> 51b0fe39549a04858001922919ab355dee9bdfcf
>         perf: Deconstify struct pmu
> 
> 
I'll not ACK this as I've no clue how the MIPS PMU(s) work, but the
shape looks ok :-)


