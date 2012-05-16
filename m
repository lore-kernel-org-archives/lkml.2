Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2EPJP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:15:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab2EPJP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:15:26 -0400
Message-ID: <4FB3702A.3040900@redhat.com>
Date: Wed, 16 May 2012 12:15:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xudong Hao <xudong.hao@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: Re: [PATCH 2/4] Add parameter to control A/D bits support
References: <20120516010818.GC14256@hp-xd.sh.intel.com>
In-Reply-To: <20120516010818.GC14256@hp-xd.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 04:08 AM, Xudong Hao wrote:
> Add kernel parameter to control A/D bits support, it's on by default.
>
> Signed-off-by: Haitao Shan <haitao.shan@intel.com>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
>
> ---
>  arch/x86/kvm/vmx.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index d2bd719..811a61e 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -64,6 +64,9 @@ static bool __read_mostly enable_unrestricted_guest = 1;
>  module_param_named(unrestricted_guest,
>             enable_unrestricted_guest, bool, S_IRUGO);
>
> +static int __read_mostly enable_ept_ad_bits = 1;
> +module_param_named(ept_ad_bits, enable_ept_ad_bits, bool, S_IRUGO);

Please use bool.  And call the external name 'eptad', for easier use.


-- 
error compiling committee.c: too many arguments to function

