Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0ERGvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:51:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0ERGvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:51:22 -0400
Date: Tue, 18 May 2010 08:53:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH 3/3] posix_timer: move copy_to_user(created_timer_id)
 down in timer_create
Message-ID: <20100518085314.1817d64a@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1274116688-4037-3-git-send-email-avagin@openvz.org>
References: <1274116688-4037-1-git-send-email-avagin@openvz.org>
	<1274116688-4037-2-git-send-email-avagin@openvz.org>
	<1274116688-4037-3-git-send-email-avagin@openvz.org>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 21:18:08 +0400
Andrey Vagin <avagin@openvz.org> wrote:

> According to Oleg Nesterov:
> We can move copy_to_user(created_timer_id) down after
> "if (timer_event_spec)" block too. (but before CLOCK_DISPATCH(),
> of course).

I'm not sure what for Oleg want that change, I'm not seeing any value of
it. I think patch should be dropped.

Thanks
Stanislaw
