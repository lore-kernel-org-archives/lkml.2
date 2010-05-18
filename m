Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0ERGsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab0ERGsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:48:10 -0400
Date: Tue, 18 May 2010 08:49:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelyanov <xemul@openvz.org>, Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH 2/3] posix_timer: fix error path in timer_create
Message-ID: <20100518084955.16e196ea@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1274116688-4037-2-git-send-email-avagin@openvz.org>
References: <1274116688-4037-1-git-send-email-avagin@openvz.org>
	<1274116688-4037-2-git-send-email-avagin@openvz.org>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 21:18:07 +0400
Andrey Vagin <avagin@openvz.org> wrote:

> move CLOCK_DISPATCH(which_clock, timer_create, (new_timer)) after all
> posible EFAULT erros.
> 
> *_timer_create may allocate/get resources.
> (for example posix_cpu_timer_create does get_task_struct)
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
