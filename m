Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0FPKSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:18:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753487Ab0FPKSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:18:13 -0400
Date: Wed, 16 Jun 2010 11:21:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: remove CONFIG_4KSTACKS
Message-ID: <20100616112136.42ab08ef@lxorguk.ukuu.org.uk>
In-Reply-To: <20100616091621.GA4486@lst.de>
References: <20100616091621.GA4486@lst.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 11:16:21 +0200
Christoph Hellwig <hch@lst.de> wrote:

> These days 4 kilobytes of stack just aren't enough for reliably operation,
> and people using lots of threads have long switched to x86-64, so remove the
> CONFIG_4KSTACKS option.

It's very useful for things like debugging and because of the split
kernel/irq stacks. It also seems to be quite adequate for most
configurations.

Perhaps XFS should select 8K stack instead ?
