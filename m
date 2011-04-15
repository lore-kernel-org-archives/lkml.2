Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1DODqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:46:09 -0400
Received: from mail.digium.com ([216.207.245.2]:52130 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1DODqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:46:07 -0400
Message-ID: <4DA7BF77.6@digium.com>
Date: Thu, 14 Apr 2011 22:45:59 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Define 'crash_kexec_wait_realmode' for Non-SMP
 systems.
References: <20110414222719.GA16256@digium.com> <4DA78A44.1000704@windriver.com>
In-Reply-To: <4DA78A44.1000704@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/11 6:59 PM, Paul Gortmaker wrote:
> On 11-04-14 06:27 PM, Shaun Ruffell wrote:
>> This fixes a regression from b987812b3fcaf70fdf0037589e5d2f5f2453e6ce
>
> A fix was already sent yesterday:
>
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-April/089559.html
>
> which relocates the stub function to where it needs to be.  Your fix
> below would end up making duplicate stub functions.

Thanks for the reply. I didn't search the linuxppp-dev list before 
sending in that patch, only the LKML. Sorry about the noise.

Cheers,
Shaun
