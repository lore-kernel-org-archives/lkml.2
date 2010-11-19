Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0KSOe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:34:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0KSOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AzOY2aM4+eGMCCQuAADWy6nZmxnNXguAxLc0yhVEX9oG+QBvFF2f9a3m+ZGVOgazr4
         ICfyGi6oywQzsuSOqmxi3LwWpBVzVTu9eTT/RPuclaKAM5rsGJvx0g/ZQ/19SUMd0o7i
         JkjkiVvQJcTmaswWiJ3K0P349OqcFf2cY5oCI=
Date: Fri, 19 Nov 2010 15:34:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, will.deacon@arm.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
Subject: Re: [PATCH 4/5] MIPS/Perf-events: Work with the new callchain
	interface
Message-ID: <20101119143416.GA5558@nowhere>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com> <1290063401-25440-5-git-send-email-dengcheng.zhu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290063401-25440-5-git-send-email-dengcheng.zhu@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:56:40PM +0800, Deng-Cheng Zhu wrote:
> This is the MIPS part of the following commits by Frederic Weisbecker:
> 
> f72c1a931e311bb7780fee19e41a89ac42cab50e
> 	perf: Factorize callchain context handling
> 56962b4449af34070bb1994621ef4f0265eed4d8
> 	perf: Generalize some arch callchain code
> 70791ce9ba68a5921c9905ef05d23f62a90bc10c
> 	perf: Generalize callchain_store()
> c1a65932fd7216fdc9a0db8bbffe1d47842f862c
> 	perf: Drop unappropriate tests on arch callchains
> 
> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> ---


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Why did I miss this arch? I did a grep on HAVE_PERF_EVENT or something,
may be it hadn't it at that time?

Thanks!

