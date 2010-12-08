Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0LHXGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:06:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab0LHXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:06:43 -0500
Date: Wed, 8 Dec 2010 15:05:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH v5 resend] OLPC: Add XO-1 suspend/resume support
Message-Id: <20101208150536.91a5f83f.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinh9RyGAKeL4weN5bWQ=pAn0NwKdb8Ru4RKkDP3@mail.gmail.com>
References: <20101203141828.33E8F9D401B@zog.reactivated.net>
	<20101208145040.e23f832d.akpm@linux-foundation.org>
	<AANLkTinh9RyGAKeL4weN5bWQ=pAn0NwKdb8Ru4RKkDP3@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 22:56:50 +0000
Daniel Drake <dsd@laptop.org> wrote:

> > Also, this checkpatch warning
> >
> > WARNING: struct platform_suspend_ops should normally be const
> > #502: FILE: arch/x86/platform/olpc/xo1.c:106:
> > +static struct platform_suspend_ops xo1_suspend_ops = {
> >
> > seems valid.
> 
> When you correct it (to make it const), gcc gives a warning, because
> suspend_set_ops() takes non-const arg.

suspend_set_ops() is fixed in linux-next.
