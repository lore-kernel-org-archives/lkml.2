Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab0FVD3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 23:29:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab0FVD3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 23:29:44 -0400
Date: Mon, 21 Jun 2010 20:28:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.34 Crash in dmaengine_put()
Message-Id: <20100621202854.de928e0a.akpm@linux-foundation.org>
In-Reply-To: <AANLkTilCW2iqsNaWM9NYIomy8OxGC9jG40KpLcKMYTqL@mail.gmail.com>
References: <AANLkTilCW2iqsNaWM9NYIomy8OxGC9jG40KpLcKMYTqL@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 20:57:40 -0600 Jeffrey Merkey <jeffmerkey@gmail.com> wrote:

> If someone sets the IFF_UP flags in the netdev structure without going
> through ifup userspace stuff, during unregister of the the netdev
> the dmaengine-put code will decrement the reference counter negative,
> and crash at BUG! in the driver/dma/dmaengine.c code.  This seems
> busted.
> 

Please send a copy of the kernel BUG trace.
