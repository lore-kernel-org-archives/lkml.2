Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2CKQVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 12:21:15 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43341 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2CKQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 12:21:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: Regression in stable tree with "genirq: Unmask oneshot irqs when thread was not woken"
Date: Sun, 11 Mar 2012 17:21:33 +0100
Message-ID: <1803644.R2cOZZcvul@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120311161059.GC3586@burratino>
References: <6626996.EEPkFOVUVF@avalon> <20120311161059.GC3586@burratino>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Sunday 11 March 2012 11:10:59 Jonathan Nieder wrote:
> Hi,
> 
> (private reply because I am not adding much)

(CC'ing the lists, as you've added the solution)

> Laurent Pinchart wrote:
> > Commit aa0eb3474beae8f6d9dcc2311dc02bea50cfd7b7 ("genirq: Unmask oneshot
> > irqs when thread was not woken") in v3.2.9 introduces a regression on the
> > Beagleboard-xM.
> 
> Does 52abb700e1 (genirq: Clear action->thread_mask if IRQ_ONESHOT is not
> set, 2012-03-06) which is queued for 3.2.10 help?

Yes, that fixes the problem. Thank you, and sorry not to have checked that 
first.

-- 
Regards,

Laurent Pinchart

