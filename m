Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0FWRv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:51:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57872 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0FWRvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BcaakNj++vqiyStRlWauGXb9qHmH23riFTV713Nr29x/RiDihdtUJoz5BovRACCTl+
         f0avuF9EHWgfnN8EZmm0O2+8uhKRTlTiJ/o+cQdO89ugoq5EZkzkJlkzTBb8VV4tsH9c
         3moMZFiao+YRiOHb6Vwuh056F8+LlbCBXB7d8=
Date: Wed, 23 Jun 2010 19:51:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: Fix argument of perf_arch_fetch_caller_regs
Message-ID: <20100623175128.GI5242@nowhere>
References: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 09:17:53AM +0900, Nobuhiro Iwamatsu wrote:
> "struct regs" was set to argument of perf_arch_fetch_caller_regs.
> "struct pt_regs" is correct.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>



Actually I'm queuing it, as I have other patches for perf in queue.

Thanks.

