Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2B0PYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:24:53 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40149 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab2B0PYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:24:51 -0500
Message-ID: <1330356289.2822.45.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] parisc: fix longstanding build failure on prefetch
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: jejb@parisc-linux.org, kyle@mcmartin.ca, deller@gmx.de,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, rientjes@google.com,
        xiyou.wangcong@gmail.com
Date: Mon, 27 Feb 2012 09:24:49 -0600
In-Reply-To: <1330289478-12603-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330289478-12603-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-26 at 15:51 -0500, Paul Gortmaker wrote:
> Upstream commit e66eed651fd18a961f11cda62f3b5286c8cc4f9f
> 
>     "list: remove prefetching from regular list iterators"
> 
> removed <linux/prefetch.h> from <linux/list.h> very early in the
> v3.0 dev cycle (v2.6.39-2-ge66eed6), thereby causing build failures
> when it exposed the implicit prefetch users in parisc.

I already have this in my internal patch queue:

http://marc.info/?l=linux-parisc&m=132825467010662

James


