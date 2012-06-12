Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2FLUhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:37:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45578 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab2FLUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:37:03 -0400
Message-ID: <4FD7A85D.4000106@zytor.com>
Date: Tue, 12 Jun 2012 13:36:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally
References: <1339533234-2265-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1339533234-2265-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 01:33 PM, Andi Kleen wrote:
>  
> +/* Global minimum microcode version */
> +int min_microcode;
> +

Any reason not to use boot_cpu_data.microcode for this, much like we do
with the CPUID common subset?

	-hpa

