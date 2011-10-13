Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1JMFjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:39:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1JMFjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:39:16 -0400
Message-ID: <4E967967.1000606@kernel.org>
Date: Wed, 12 Oct 2011 22:38:47 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, jbeulich@novell.com,
        fenghua.yu@intel.com, khali@linux-fr.org
Subject: Re: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v3
References: <1318466795-7393-1-git-send-email-andi@firstfloor.org> <1318466795-7393-3-git-send-email-andi@firstfloor.org>
In-Reply-To: <1318466795-7393-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 05:46 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the ucode revision is available in cpu_data remove
> the existing code in coretemp.c to query it manually. Read the ucode
> revision from cpu_data instead
> 
> v2: Fix misplaced variable init. Remove unused variables.
> v3: Port to latest tree
> Cc: jbeulich@novell.com
> Cc: fenghua.yu@intel.com
> Cc: khali@linux-fr.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

