Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0IAI6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:58:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44275 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0IAI56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:57:58 -0400
Date: Wed, 1 Sep 2010 09:57:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce
	devices
Message-ID: <20100901085738.GJ8142@n2100.arm.linux.org.uk>
References: <20100819174426O.fujita.tomonori@lab.ntt.co.jp> <m3sk1yzkjw.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3sk1yzkjw.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 07:58:11PM +0200, Krzysztof Halasa wrote:
> What's the outcome of the following?
> 
> Russell, are you going to apply it as is, or is a better (short-term)
> fix being made?

I want to see a better solution to this first - without which we'll
apply this hack and then quietly forget about the problem.
