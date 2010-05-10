Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0EJWsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:48:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203Ab0EJWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:48:00 -0400
Date: Mon, 10 May 2010 15:46:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch]hp_accel: Fix race in device removal
Message-Id: <20100510154632.bbe181d8.akpm@linux-foundation.org>
In-Reply-To: <201005071804.20462.oneukum@suse.de>
References: <201005071804.20462.oneukum@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 18:04:20 +0200
Oliver Neukum <oneukum@suse.de> wrote:

> >From 505056649f5ecb1ebb086981243b9870ce961a87 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Fri, 7 May 2010 18:02:07 +0200
> Subject: [PATCH] hp_accel: Fix race in device removal
> 
> The work queue has to be flushed after the device has been made
> inaccessible.
> 

You cc'ed stable@kernel.org so presumably you think it's a pretty
serious bug.

But alas, I (and presumably others) cannot confirm that, because you
didn't describe the bug :( This also means that if someone hits a
problem with this driver, they won't easily be able to work out whether
this patch will fix it.


Under what circumstances does it trigger?

What are the observed effects when it triggers?

Please always include this sort of information when sending bugfixes, thanks.
