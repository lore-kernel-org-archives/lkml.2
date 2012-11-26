Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2KZXUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:20:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab2KZXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:20:03 -0500
Date: Mon, 26 Nov 2012 15:20:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: linux-next: Tree for Nov 26 (staging/fwserial)
Message-Id: <20121126152001.bf346786.akpm@linux-foundation.org>
In-Reply-To: <50B3D767.70604@infradead.org>
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
	<50B3D767.70604@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012 12:56:07 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/26/2012 06:17 AM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20121115:
> > 
> 
> 
> on i386:
> 
> drivers/staging/fwserial/dma_fifo.c: In function 'dma_fifo_in':
> drivers/staging/fwserial/dma_fifo.c:174:2: error: implicit declaration of function '__WARN_printf'
> 

That should be replaced with WARN(fifo->corrupt, format).

drivers/staging/fwserial/dma_fifo.[ch] appear to be generic code and
really should be proposed for mm/ or lib/.

