Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2IXNK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:10:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2IXNK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:10:28 -0400
Message-ID: <1348492217.11847.60.camel@twins>
Subject: Re: [PATCH 2/2] [RESEND] console: implement lockdep support for
 console_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 24 Sep 2012 15:10:17 +0200
In-Reply-To: <CAKMK7uGyDOhCtP_fCRa-oirQ8edQcSiW8L_vSE9M29LU3EUoqg@mail.gmail.com>
References: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch>
	 <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
	 <1348489027.11847.53.camel@twins> <1348489478.11847.55.camel@twins>
	 <CAKMK7uGyDOhCtP_fCRa-oirQ8edQcSiW8L_vSE9M29LU3EUoqg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 14:54 +0200, Daniel Vetter wrote:
> I've read through the patches and I'm hoping you don't volunteer me to
> pick these up ... ;-) 

Worth a try, right? :-)

> But there doesn't seem to be anything that would
> get worse through this lockdep annotation patch, right? 

No indeed, your patch looks fine, I just wanted to comment on the
printk() thing.
