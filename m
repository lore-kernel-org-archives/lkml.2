Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0FRCOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:14:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42814 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0FRCOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VPOb+xrFHVnFDANazuA2NK1H7YvarNzHXGfrpW8NFblt1HSjwzKzSFz3/NFEvo+oBi
         8dNzz5LvCN2HXKoqWGQZ7GGcv6eTSFlGqZRuRGN/i5nioB9B8JGnB+XKJqV3WR3sswl5
         vwEOtQPLuoJg/tznE3XqPS4vpc3HZf2Fplcc4=
Date: Fri, 18 Jun 2010 04:14:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/8] perf: Per PMU disable
Message-ID: <20100618021405.GD5345@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.529009255@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616160238.529009255@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:33PM +0200, Peter Zijlstra wrote:
> +static void armpmu_pmu_enable(struct pmu *pmu)
>  {
> +static void powerpc_pmu_pmu_disable(struct pmu *pmu)
>  {
> +static void fsl_emb_pmu_pmu_disable(struct pmu *pmu)
>  {
> +static void sh_pmu_pmu_enable(struct pmu *pmu)
> +{
> +static void sparc_pmu_pmu_enable(struct pmu *pmu)
>  {
> +static void x86_pmu_pmu_disable(struct pmu *pmu)
>  {


These namings are really bad. Why not just using pmu once
in each names? x86_pmu_enable, etc...

