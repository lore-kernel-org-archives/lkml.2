Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2EYKtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:49:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42228 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2EYKtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:49:13 -0400
Message-ID: <4FBF5FAF.4010906@linux.vnet.ibm.com>
Date: Fri, 25 May 2012 16:02:15 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf record: Fixing record option data type in parse_branch_stack
References: <4FBDFDA6.5010304@linux.vnet.ibm.com> <4FBF185F.4060007@linux.vnet.ibm.com>	<4FBF3CD1.7030603@linux.vnet.ibm.com> <CABPqkBS6cdUkKgC1Jp_pzMWxDKZYJtomoZUx6g2z739y=TkPAw@mail.gmail.com>
In-Reply-To: <CABPqkBS6cdUkKgC1Jp_pzMWxDKZYJtomoZUx6g2z739y=TkPAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052510-4790-0000-0000-000002F11B52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2012 02:14 PM, Stephane Eranian wrote:

> Hi,
> 
> It should be something like that instead:
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 8a9687e..c9ca7c4 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -228,7 +228,7 @@ struct perf_record_opts {
>         unsigned int freq;
>         unsigned int mmap_pages;
>         unsigned int user_freq;
> -       int          branch_stack;
> +       u64          branch_stack;
>         u64          default_interval;
>         u64          user_interval;
>  };
> 



Agreed. I just tried to fix the problem where it was more evident because
of the data type mismatch.

