Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1KFVQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:16:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KFVQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:16:04 -0500
MIME-Version: 1.0
In-Reply-To: <201111062210.11759.rjw@sisk.pl>
References: <20111103223113.GR4417@google.com>
	<201111061312.56256.rjw@sisk.pl>
	<20111106164755.GA13699@google.com>
	<201111062210.11759.rjw@sisk.pl>
Date: Sun, 6 Nov 2011 13:16:02 -0800
X-Google-Sender-Auth: ZzmxLw63zqr1Yrsolk1dzYI-8SA
Message-ID: <CAOS58YOAKK_tVfwsfnEzNZpH1e=4OA52v9yE+ymGk7LfQB4+OA@mail.gmail.com>
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Nov 6, 2011 at 1:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Do you mean something like this is needed on top of linux-pm/pm-freezer:
>
> ---
>  kernel/freezer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-pm/kernel/freezer.c
> ===================================================================
> --- linux-pm.orig/kernel/freezer.c
> +++ linux-pm/kernel/freezer.c
> @@ -90,7 +90,7 @@ static void fake_signal_wake_up(struct t
>        unsigned long flags;
>
>        if (lock_task_sighand(p, &flags)) {
> -               signal_wake_up(p, 1);
> +               signal_wake_up(p, 0);

Yeap, that was the only discrepancy I could find.

Thanks.

-- 
tejun
