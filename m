Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0LFWcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:32:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59336 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0LFWcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:32:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 resend] OLPC: Add XO-1 suspend/resume support
Date: Mon, 6 Dec 2010 23:31:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Daniel Drake <dsd@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>
References: <20101203141828.33E8F9D401B@zog.reactivated.net> <alpine.LFD.2.00.1012062119350.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012062119350.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012062331.26953.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010, Thomas Gleixner wrote:
> On Fri, 3 Dec 2010, Daniel Drake wrote:
...
> > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > index 7335952..c320724 100644
> > --- a/kernel/power/suspend.c
> > +++ b/kernel/power/suspend.c
> > @@ -42,6 +42,7 @@ void suspend_set_ops(struct platform_suspend_ops *ops)
> >  	suspend_ops = ops;
> >  	mutex_unlock(&pm_mutex);
> >  }
> > +EXPORT_SYMBOL_GPL(suspend_set_ops);
> 
> Has this been acked by the PM folks ?

Nope.

Rafael
