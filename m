Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1JMFim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:38:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36076 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1JMFil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:38:41 -0400
Message-ID: <4E96794E.5070905@kernel.org>
Date: Wed, 12 Oct 2011 22:38:22 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
References: <1318466795-7393-1-git-send-email-andi@firstfloor.org> <1318466795-7393-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1318466795-7393-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 05:46 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the cpu update level is available the Atom PSE errata
> check can use it directly without reading the MSR again.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>
