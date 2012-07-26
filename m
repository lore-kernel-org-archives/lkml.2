Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2GZH0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:26:00 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38812 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab2GZHZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <1343251216-24106-1-git-send-email-ccross@android.com>
References: <1343251216-24106-1-git-send-email-ccross@android.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 26 Jul 2012 09:25:36 +0200
Message-ID: <CAMQu2gzh1=rkTuBr+RRtnzb0m9ZpqSY9X0o92q4BAQXNENoSQw@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
To: Colin Cross <ccross@android.com>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 11:20 PM, Colin Cross <ccross@android.com> wrote:
> The cpu hotplug notifier gets called in both atomic and non-atomic
> contexts, it is not always safe to lock a mutex.  Filter out all events
> except the six necessary ones, which are all sleepable, before taking
> the mutex.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
Agree.
Have you observed any lock-up ?

For that patch itself, Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
