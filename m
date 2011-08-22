Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1HVWMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:12:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab1HVWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:12:14 -0400
Date: Mon, 22 Aug 2011 15:12:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Magnus Damm <damm@opensource.se>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: add missing include of linux/module.h
Message-Id: <20110822151200.1d6e03f7.akpm@linux-foundation.org>
In-Reply-To: <1313936407.13671.1.camel@phoenix>
References: <1313936407.13671.1.camel@phoenix>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Aug 2011 22:20:07 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Add missing include of linux/module.h for drivers that
> use interfaces from linux/module.h.  This patch fixes build errors.
> 
> ...
>
>  drivers/leds/leds-ams-delta.c   |    1 +
>  drivers/leds/leds-hp6xx.c       |    1 +
>  drivers/leds/leds-renesas-tpu.c |    1 +

I'm seeing no leds-renesas-tpu.c in my tree, so whatever tree holds
that file will remain unfixed.

