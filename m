Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1JMFiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:38:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1JMFiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:38:16 -0400
Message-ID: <4E967930.1020409@kernel.org>
Date: Wed, 12 Oct 2011 22:37:52 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision v6
References: <1318466795-7393-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1318466795-7393-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 05:46 PM, Andi Kleen wrote:
> 
> I had to add a memory barrier to native_cpuid to prevent it being
> optimized away when the result is not used.
> 

This is BAD... this means gcc is optimizing away an asm volatile, which
should never happen.  Please report a gcc bug.  What version of gcc is this?

Other than that,

Acked-by: H. Peter Anvin <hpa@zytor.com>
