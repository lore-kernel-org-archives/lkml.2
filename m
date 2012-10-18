Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2JRIEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:04:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41863 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2JRIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:04:35 -0400
Subject: Re: [PATCH v3] posix timers: allocate timer id per process
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        devel@openvz.org, linux-kernel@vger.kernel.org
In-Reply-To: <20121018074953.14057.52370.stgit@localhost.localdomain>
References: <20121018074953.14057.52370.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Oct 2012 10:04:30 +0200
Message-ID: <1350547470.26103.1158.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 11:49 +0400, Stanislav Kinsbursky wrote:


> +
> +static struct k_itimer *__posix_timers_find(struct hlist_head *head, struct signal_struct *sig, timer_t id)

This line is too long

Please use scripts/checkpatch.pl

Other than that, your patch seems fine to me

Thanks


