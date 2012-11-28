Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2K1TgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:36:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28155 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2K1TgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:36:20 -0500
Date: Wed, 28 Nov 2012 14:35:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/46] x86, mm: map ram from top-down with BRK and
 memblock.
Message-ID: <20121128193523.GA18843@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <20121127211755.GC10391@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127211755.GC10391@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:17:55PM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 16, 2012 at 07:38:37PM -0800, Yinghai Lu wrote:
> > rebase patchset together tip/x86/mm2 on top of linus v3.7-rc4
> > 
> 
> Pardon me for taking so long to respond. Right after you posted it I had
> a mini-conference and then vacation and I am just now unburrying myself
> from email avalanche.
> 
> I will take a look at them tomorrow and review them.

Have done so. I really like how the top-down mechanism works. It is pretty neat!

Yinghai, I had mostly just comments about the patch descriptions -  I would
appreciate it you could modify the patches to address the little nitpicks I
spotted. And while doing that you can stick
'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>' on all patches.

For the "x86, mm, Xen: Remove mapping_pagetable_reserve()"
you can also put 'Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'

Thank you!

