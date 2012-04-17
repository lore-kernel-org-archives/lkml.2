Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2DQUoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:44:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:58344 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2DQUoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:44:02 -0400
Date: Tue, 17 Apr 2012 22:43:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard@nod.at>
cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] irq: Remove irq_chip->release()
In-Reply-To: <1334695036-19977-4-git-send-email-richard@nod.at>
Message-ID: <alpine.LFD.2.02.1204172243110.2542@ionos>
References: <1334695036-19977-1-git-send-email-richard@nod.at> <1334695036-19977-4-git-send-email-richard@nod.at>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Richard Weinberger wrote:

> As it's only user (UML) does no longer need it we can get
> rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Nice work!

Please add my Reviewed-by to the series.

Thanks,

	tglx
