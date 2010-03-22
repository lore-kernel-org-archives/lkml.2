Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0CVTbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:31:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970Ab0CVTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:31:20 -0400
Date: Mon, 22 Mar 2010 12:30:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Vrabel <david.vrabel@csr.com>, Pierre Ossman <pierre@ossman.eu>,
       Ben Dooks <ben@simtec.co.uk>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sdhci-pltfm: Do not print errors in case of an
 extended iomem size
Message-Id: <20100322123052.10820d0f.akpm@linux-foundation.org>
In-Reply-To: <4BA0708C.8070402@pelagicore.com>
References: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
	<20100316183430.GC25670@oksana.dev.rtsoft.ru>
	<4BA0708C.8070402@pelagicore.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 07:02:52 +0100
Richard R__jfors <richard.rojfors@pelagicore.com> wrote:

> On 3/16/10 7:34 PM, Anton Vorontsov wrote:
> > Some hosts have an extended SDHCI iomem size, so the driver should
> > only print errors if the iomem size is less than 0x100.
> 
> With this change you allow a bigger resource than we really need.
> I think you should also change request_mem_region and ioremap to only
> request and map the actual needed size. (0x100)

I merged these three with a note-to-self that some updates are expected
(hint).

