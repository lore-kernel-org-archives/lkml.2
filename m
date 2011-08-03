Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1HCWfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:35:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34340 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1HCWfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:35:48 -0400
Message-ID: <4E39CD3C.8010801@zytor.com>
Date: Wed, 03 Aug 2011 15:35:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, xen-devel@lists.xensource.com
Subject: Re: [PATCH 3/5] cpuidle: replace xen access to x86 pm_idle and default_idle
References: <1312400648-17636-1-git-send-email-lenb@kernel.org> <0c70c6b12c37ececbfa9b7734495835514f273a4.1312400543.git.len.brown@intel.com>
In-Reply-To: <0c70c6b12c37ececbfa9b7734495835514f273a4.1312400543.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:44 PM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> When a Xen Dom0 kernel boots on a hypervisor, it gets access
> to the raw-hardware ACPI tables.  While it parses the idle tables
> for the hypervisor's beneift, it uses HLT for its own idle.
> 
> Rather than have xen scribble on pm_idle and access default_idle,
> have it simply disable_cpuidle() so acpi_idle will not load and
> architecture default HLT will be used.
> 
> cc: xen-devel@lists.xensource.com
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/xen/setup.c      |    3 ++-
>  drivers/cpuidle/cpuidle.c |    4 ++++
>  include/linux/cpuidle.h   |    2 ++
>  3 files changed, 8 insertions(+), 1 deletions(-)
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

