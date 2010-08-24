Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0HXMO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0HXMOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:14:24 -0400
Date: Tue, 24 Aug 2010 14:11:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [RFC PATCH 1/3] timer: fix comments of try_to_del_timer_sync()
Message-ID: <20100824121109.GA13061@redhat.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com> <1282633129-9187-2-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282633129-9187-2-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Yong Zhang wrote:
>
> From: Yong Zhang <yong.zhang@windriver.com>
>
> In commit fd450b7318b75343fd76b3d95416853e34e72c95, it was saying
> try_to_del_timer_sync() can be used in interrupt context.

Yes, but not in UP case.

Please remove "#ifdef CONFIG_SMP" from set_running_timer(), then iirc
it can be used from irq.

Oleg.

