Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0IYBzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 21:55:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab0IYBzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 21:55:02 -0400
Message-ID: <4C9D5643.10505@zytor.com>
Date: Fri, 24 Sep 2010 18:54:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FW: [RFC PATCH] [X86/mem] Optimize memmove for small size and
 unaligned cases
References: <C10D3FB0CD45994C8A51FEC1227CE22F139131A574@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F139131A574@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 06:36 PM, Ma, Ling wrote:
> Any comments ?
> 
> Thanks
> Ling

Sorry... thought I had applied this one already -- looks like that was
really another patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

