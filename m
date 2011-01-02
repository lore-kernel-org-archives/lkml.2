Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1ABJP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:15:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55035 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ABJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LJgB9/oxOKZLFVZktf08+xP7RsCQsAKotT0uKcMUS3xPO6w/xSdl1fIUOo4nMeCb6Q
         33B/iR3SNiVjP0ZiG0ieG9OsZd1E7hl/vUZ/BhYyjoEJ2o8/ZYWfYWSrsBzk35hMej5b
         wUZLQxiXCf45l4jy8xPymY+3LGAKv+SQ/jYs4=
Subject: Re: [PATCH] Prevent users from disabling tickless
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110102085755.GA32469@atrey.karlin.mff.cuni.cz>
References: <20101221233942.GL1263@parisc-linux.org>
	 <20110102085755.GA32469@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 10:15:42 +0100
Message-ID: <1293959742.2535.73.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 janvier 2011 à 09:57 +0100, Pavel Machek a écrit :
> Hi!
> 
> > Disabling NO_HZ has a serious negative effect on performance -- an extra
> > 70us per I/O.  Prevent users from deselecting it.
> > 
> > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> System with fixed HZ is really simpler etc... and 70us per i/o does
> not sound that bad.
> 
> Anyway, should not i/o overhead just be fixed?

Also, where are those 70us spent exactly ? Once per clock tick ?

For me, I/O can be an ethernet frame sent or received, and I never
noticed such a delay.

At least, commit message sounds very evasive too me.



