Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab0FPUrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:47:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759527Ab0FPUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:47:23 -0400
Date: Wed, 16 Jun 2010 13:46:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Slaby <jslaby@suse.cz>, rpurdie@rpsys.net,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 1/1] LEDS: leds-input, fix sleep inside atomic
Message-Id: <20100616134646.3f7870e7.akpm@linux-foundation.org>
In-Reply-To: <20100605234505.GZ5358@const.famille.thibault.fr>
References: <1275772342-25094-1-git-send-email-jslaby@suse.cz>
	<20100605234505.GZ5358@const.famille.thibault.fr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010 01:45:06 +0200
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Jiri Slaby, le Sat 05 Jun 2010 23:12:22 +0200, a __crit :
> > Fix this by changing the spinlock to mutex as it is used only in
> > input_handler->connect and ->disconnect and it is safe to sleep
> > there.
> 
> Right. in a previous patch it was also used in interrupt context, but
> now it should be safe indeed.
> 
> Andrew, please fold it into the leds-input patch.

hm, I did, nine days ago;

btw, leds-route-kbd-leds-through-the-generic-leds-layer.patch is still
in the "stuck" state coz Alessandro said he'd test it ;)

I think I'll start pestering Richard with it anyway.

