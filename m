Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2KZU4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:56:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:35008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2KZU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:56:16 -0500
Message-ID: <50B3D767.70604@infradead.org>
Date: Mon, 26 Nov 2012 12:56:07 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: linux-next: Tree for Nov 26 (staging/fwserial)
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
In-Reply-To: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 06:17 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20121115:
> 


on i386:

drivers/staging/fwserial/dma_fifo.c: In function 'dma_fifo_in':
drivers/staging/fwserial/dma_fifo.c:174:2: error: implicit declaration of function '__WARN_printf'


-- 

~Randy
