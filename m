Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2KQAnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:43:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37817 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab2KQAnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:43:11 -0500
Message-ID: <50A6DD92.1060304@zytor.com>
Date: Fri, 16 Nov 2012 16:42:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86: Move some contents of page_64_types.h into
 pgtable_64.h and page_64.h
References: <20121116215244.8521.31505.stgit@ahduyck-cp1.jf.intel.com> <tip-66d61384e9b4087f044ce86cb4adb12fe4623a6b@git.kernel.org> <CAE9FiQUHoK-Ayj2-V6b1vj0FSu82CEWfy9NrW9jqjxwWX3YeOw@mail.gmail.com>
In-Reply-To: <CAE9FiQUHoK-Ayj2-V6b1vj0FSu82CEWfy9NrW9jqjxwWX3YeOw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 04:30 PM, Yinghai Lu wrote:
> 
> arch/x86/kernel/apic/apic_numachip.c: In function ‘map_csrs’:
> arch/x86/kernel/apic/apic_numachip.c:158:2: error: implicit
> declaration of function ‘init_extra_mapping_uc’
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 

A missing #include; I folded the fix and re-pushed the branch.

	-hpa

