Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab0DAUZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:25:12 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:40410 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab0DAUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:25:05 -0400
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 16:25:05 EDT
Date: Thu, 1 Apr 2010 16:12:07 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] ibft, x86: Change reserve_ibft_region() to find_ibft_region()
Message-ID: <20100401201206.GA19462@andromeda.dapyr.net>
References: <4BB3FFE4.4010909@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB3FFE4.4010909@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 07:07:32PM -0700, Yinghai Lu wrote:
> 
> 
> So arch code could decide the way to reserve the ibft.
> 
> And We should reserve ibft as early as possible, instead of BOOTMEM stage,
> in case the table is in RAM range and is not reserved by BIOS.

What test vehicle did you use to find this bug?


.. snip..
> +	if (size)
> +		reserve_early_overlap_ok(addr, addr + size, "ifbt");
							     ^^^^ - ibft

