Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2EFNKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:10:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46378 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753543Ab2EFNKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:10:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qQ/d5z2Fq5/Stiho7miWfY8MTHdXF6vX2AvbE4J
	bufWwjNf1hdwYm
Message-ID: <1336309806.7351.19.camel@marge.simpson.net>
Subject: Re: [PATCH] clockevents: Per cpu tick skew boot option
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 06 May 2012 15:10:06 +0200
In-Reply-To: <1336309127.7351.13.camel@marge.simpson.net>
References: <1336309127.7351.13.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-06 at 14:58 +0200, Mike Galbraith wrote:

> - 0209f649 rcu: limit rcu_node leaf-level fanout
>   This patch was born to combat lock contention which testing showed
>   to have been _induced by_ skew removal.  Skew the tick, contention
>   disappeared virtually completely.

P.S.  This boot option patch will complement a proposed patch by Paul
McKenney to allow boot time fanout configuration.  Between the two,
users will then be able to boot time select the tradeoff they need for
optimal performance of their systems.

-Mike


