Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab1ERKvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:51:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:58466 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab1ERKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:51:14 -0400
Date: Wed, 18 May 2011 12:51:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH V4] irq: uninline generic_handle_irq, export handle_simple_irq,
 irq_modify_status, generic_handle_irq, irq_alloc_descs and irq_free_descs
In-Reply-To: <1305711544-505-1-git-send-email-jic23@cam.ac.uk>
Message-ID: <alpine.LFD.2.02.1105181249470.3078@ionos>
References: <1305711544-505-1-git-send-email-jic23@cam.ac.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, Jonathan Cameron wrote:
> Hi Thomas,
> 
> Looking a bit more at possible locations it is clear that CONFIG_GENERIC_HARDIRQS
> only exists as an ifdef in irqdesc.c so I guess that is the least intrusive place
> to move this to.

Bah, that ifdef there is completely useless. kernel/irq/ is only built
when CONFIG_GENERIC_HARDIRQS=y. I fix that.

Thanks,

	tglx
