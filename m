Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1DLRrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:47:32 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:33670 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757993Ab1DLRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:47:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LdL07qp4tvDcqoZl6rRHufj+jsbxTMbppLiFRFCgjpPCfauR2M6ZN82MuR5JpYUDXEg9zRDyCq4ipNOsdtN8kj1QtbwF0HNMeDqSJJ/3sR2dUhwstbdT0UygDgEUDTF6;
Date: Tue, 12 Apr 2011 10:47:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: Remove dma32_reserve_bootmem
Message-ID: <20110412104716.5388849d@jbarnes-desktop>
In-Reply-To: <4DA489F0.4000003@kernel.org>
References: <4D90CBE5.6090706@kernel.org>
	<20110412091145.2bc5e6a9@jbarnes-desktop>
	<4DA489F0.4000003@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 10:20:48 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> That is workaround for holding dma32 buf when early bootmem could use up
> those range on system that have lots of RAM.
> 
> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
> 
> So We could remove those not needed code now.
> 
> -v2: rebase on pci-next
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Hm, still didn't apply cleanly, I guess the patch got corrupted.  I
fixed it up by hand and applied to linux-next though, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
