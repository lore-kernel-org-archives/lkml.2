Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2IGSnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:43:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33479 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab2IGSnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:43:24 -0400
Message-ID: <504A403F.10501@zytor.com>
Date: Fri, 07 Sep 2012 11:43:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@kernel.org, torvalds@linux-foundation.org, andreas.herrmann3@amd.com,
        bp@amd64.org, robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, fpu: enable eagerfpu by default for xsaveopt
References: <1347042703-11128-1-git-send-email-suresh.b.siddha@intel.com> <1347042703-11128-2-git-send-email-suresh.b.siddha@intel.com>
In-Reply-To: <1347042703-11128-2-git-send-email-suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 11:31 AM, Suresh Siddha wrote:
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6273099..b21bcbd 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1835,7 +1835,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   			enabling legacy floating-point and sse state.
>
>   	eagerfpu=	[X86]
> -			on	enable eager fpu restore
> +			on	enable eager fpu restore (default for xsaveopt)
>   			off	disable eager fpu restore
>

Should we make this a tristate (on, off, default/auto)?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

