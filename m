Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1JaHsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 03:48:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54879 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1JaHsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 03:48:16 -0400
Date: Mon, 31 Oct 2011 15:48:36 +0800
From: Shan Hai <haishan.bai@gmail.com>
To: Santosh Kumar <santoshkumar.a@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: powerpc 476, Little-endian, pte fault
Message-ID: <20111031074836.GB4910@ubuntu.corp.ad>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 11:00:14AM +0530, Santosh Kumar wrote:
> KERNEL: linux 2.6.39.4
> POWERPC: 476, little endian.
> 
> I am trying to get linux 2.6.39.4 up on PPC 476 i have done done
> Big-endian to little endian Changes in:
> 1) bitops header file.
> 2) while reading the device tree.
> 3) the PTE read/computed in head_32.S
> 4) added E bit in the TLB entries.
> 
> with all the above changes the kernel_init is done but and inited is mounted.
> 
> But while spawning init process the kernel continuously hits pte
> faults at address 0x100000fc and never comes out. Please let me know
> where i should be looking into.
> 

Please check whether the following commit is there in your tree.
2efaca927f5cd7ecd0f1554b8f9b6a9a2c329c03

Cheers
Shan Hai

> -
> Thanks
> Santosh Kumar .A
> 
> Vision without Action is a daydream... Action without Vision is a nightmare...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
