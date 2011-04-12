Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1DLQM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:12:28 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57041 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758082Ab1DLQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:12:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XvvGJZv5dpfq1PzjP5jUAMedaqH6L+3f0e4mJYojd48Fm3ZYL31Le6RaBdyKNH2Pl5Im+5ZfhjwL0D6lHtnE0njtHUnlQV4CNZxWK/xzWo5BtA2Z9qUDaG0Uclo6snGH;
Date: Tue, 12 Apr 2011 09:11:45 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove dma32_reserve_bootmem
Message-ID: <20110412091145.2bc5e6a9@jbarnes-desktop>
In-Reply-To: <4D90CBE5.6090706@kernel.org>
References: <4D90CBE5.6090706@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 10:56:53 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> That is workaround for holding dma32 buf when early bootmem could use up
> those range on system that have lots of RAM.
> 
> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
> 
> So We could remove those not needed code now.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Looks like a nice cleanup, can you re-send based on my linux-next
branch?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
