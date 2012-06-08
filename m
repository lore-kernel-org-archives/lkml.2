Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333Ab2FHSQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:16:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040Ab2FHSQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:16:35 -0400
Message-ID: <4FD24173.4060807@zytor.com>
Date: Fri, 08 Jun 2012 11:16:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 5/5] x86, cacheinfo, amd: fix reported cache parameters
 for family 0x10
References: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com> <1339087559-32604-5-git-send-email-hans.rosenfeld@amd.com>
In-Reply-To: <1339087559-32604-5-git-send-email-hans.rosenfeld@amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 09:45 AM, Hans Rosenfeld wrote:
> +			unsigned int reg;
> +			pci_read_config_dword(nb->misc, 0x1d4, &reg);
> +			if ((reg & 0x3))
> +				assoc -= 8;
> +		}

/home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/cpu/amd_cacheinfo.c: In
function ‘amd_cpuid4’:
/home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/cpu/amd_cacheinfo.c:127:13:
warning: ‘reg’ may be used uninitialized in this function [-Wuninitialized]

Please don't send patchsets which introduce new warnings.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

