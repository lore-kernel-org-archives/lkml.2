Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1HCWgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:36:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34346 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab1HCWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:36:07 -0400
Message-ID: <4E39CD52.9040504@zytor.com>
Date: Wed, 03 Aug 2011 15:36:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org
Subject: Re: [PATCH 4/5] x86 idle: move mwait_idle_with_hints() to where it
 is used
References: <1312400648-17636-1-git-send-email-lenb@kernel.org> <779d881fbcdf840e23a9bd3e237aebca4e0376e8.1312400543.git.len.brown@intel.com>
In-Reply-To: <779d881fbcdf840e23a9bd3e237aebca4e0376e8.1312400543.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:44 PM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> ...and make it static
> 
> no functional change
> 
> cc: x86@kernel.org
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/include/asm/processor.h |    2 --
>  arch/x86/kernel/acpi/cstate.c    |   23 +++++++++++++++++++++++
>  arch/x86/kernel/process.c        |   23 -----------------------
>  3 files changed, 23 insertions(+), 25 deletions(-)
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

