Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1JXJZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:25:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:56493 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab1JXJZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:25:50 -0400
Date: Mon, 24 Oct 2011 11:25:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 4/5] workqueue: hotplug fix
In-Reply-To: <20111024022648.GA24581@zhy>
Message-ID: <alpine.LFD.2.02.1110241124590.2642@ionos>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com> <1318762607-2261-5-git-send-email-yong.zhang0@gmail.com> <alpine.LFD.2.02.1110190913320.3240@ionos> <20111024022648.GA24581@zhy>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011, Yong Zhang wrote:
> On Wed, Oct 19, 2011 at 09:14:28AM +0200, Thomas Gleixner wrote:
> > > -	spin_unlock_irqrestore(&gcwq->lock, flags);
> > 
> > This part of the patch is pretty pointless.
> 
> But CPU_STARTING is called with irq disabled, and it will take
> the lock unconditionally. Thus below warning is triggered:

Aarg, yes.

Thanks,

	tglx
