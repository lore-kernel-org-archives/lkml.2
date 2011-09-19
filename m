Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab1ISWgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:36:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42638 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1ISWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:36:50 -0400
Date: Tue, 20 Sep 2011 00:36:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to signal_struct v4
Message-ID: <20110919223649.GO7761@one.firstfloor.org>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org> <1316471007.2455.24.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316471007.2455.24.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This means idr_pre_get() consumes 6528 bytes of spare space per process,
> even if only one posix timer is used.

And? Given the now normal bloat level in the kernel that's small
potatoes.

The idr code is so messy that I don't really want to touch it.

If you think it is that important feel free to do a followon 
patch.

If it's that big a problem I'm sure a general solution would
be better than some quick hack for a special case.

-Andi
