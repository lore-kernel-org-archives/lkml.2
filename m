Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0LPIXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 03:23:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab0LPIXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 03:23:06 -0500
Date: Thu, 16 Dec 2010 00:20:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delay.h: add __must_check to msleep_interruptible
Message-Id: <20101216002010.2ae6b9cb.akpm@linux-foundation.org>
In-Reply-To: <20101216061711.GC26083@jasper.tkos.co.il>
References: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
	<20101216061711.GC26083@jasper.tkos.co.il>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 08:17:11 +0200 Baruch Siach <baruch@tkos.co.il> wrote:

> On Thu, Nov 04, 2010 at 10:55:41AM +0200, Baruch Siach wrote:
> > Code calling msleep_interruptible() must be aware that sleep time might be
> > shorter than intended as a result of a signal being caught. Code not checking
> > the return value of msleep_interruptible() is probably buggy, unless it's doing
> > the signal_pending() check itself, which is redundant.
> 
> Ping?

Stuck in my backlog.  Delayed but not forgotten.
