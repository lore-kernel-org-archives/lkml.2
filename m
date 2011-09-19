Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab1ISWmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:42:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45188 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab1ISWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:42:22 -0400
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20110919223649.GO7761@one.firstfloor.org>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
	 <1316471007.2455.24.camel@edumazet-laptop>
	 <20110919223649.GO7761@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 00:41:36 +0200
Message-ID: <1316472096.2455.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 20 septembre 2011 à 00:36 +0200, Andi Kleen a écrit :
> > This means idr_pre_get() consumes 6528 bytes of spare space per process,
> > even if only one posix timer is used.
> 
> And? Given the now normal bloat level in the kernel that's small
> potatoes.
> 

I see. Oh yes, you work for a known hardware vendor.

> The idr code is so messy that I don't really want to touch it.
> 
> If you think it is that important feel free to do a followon 
> patch.
> 
> If it's that big a problem I'm sure a general solution would
> be better than some quick hack for a special case.

I'll provide not a hack but a clean patch for this.

I read once idr code, and its not messy at all.



