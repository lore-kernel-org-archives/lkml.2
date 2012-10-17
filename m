Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2JQVlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:41:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JQVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:41:18 -0400
Message-ID: <507F25F3.1010301@canonical.com>
Date: Wed, 17 Oct 2012 23:41:07 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: allow unsetting SCHED_RESET_ON_FORK when new policy
 is not realtime
References: <507F20AC.6000308@canonical.com>
In-Reply-To: <507F20AC.6000308@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 17-10-12 23:18, Maarten Lankhorst schreef:
> When implementing SIGXCPU handling for a thread boosted with rtkit to realtime
> priority, I noticed that sched_setscheduler(somepid, SCHED_OTHER) would return
> -EPERM because the thread was previously SCHED_RR | SCHED_RESET_ON_FORK,
> and looking from the code that flag cannot be reset without sufficient rights.
>
Argh must not send patches right before going to bed, this leaves open a hole
if current policy is sched_idle and when nice level is at a privileged level still..

Not that I've ever seen nice level do anything. Will resend after I've had some sleep.

~Maarten
