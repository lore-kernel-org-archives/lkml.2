Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2D3W6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:58:05 -0400
Received: from linux-sh.org ([111.68.239.195]:60238 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab2D3W6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:58:03 -0400
Date: Tue, 1 May 2012 07:57:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [patch 22/29] sh: Use generic init_task
Message-ID: <20120430225749.GE7988@linux-sh.org>
References: <20120430194725.763322463@linutronix.de>
 <20120430194846.924135890@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430194846.924135890@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:16:02PM -0000, Thomas Gleixner wrote:
> Same code. Use the generic version. The special Makefile treatment is
> pointless anyway as init_task.o contains only data which is handled by
> the linker script. So no point on being treated like head text.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
