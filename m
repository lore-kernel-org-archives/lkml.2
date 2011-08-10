Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1HJJql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:46:41 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40577 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab1HJJqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:46:40 -0400
Date: Wed, 10 Aug 2011 11:46:32 +0200
From: Florian Mickler <florian@mickler.org>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org, error27@gmail.com
Subject: Re: [PATCH] [media] vp7045: fix buffer setup
Message-ID: <20110810114632.699ba9dc@schatten.dmk.lab>
In-Reply-To: <20110809200842.GA29662@mac.home>
References: <20110722192722.GA9369@x61.home>
	<1312288145-22292-1-git-send-email-florian@mickler.org>
	<20110803190204.GA18377@mac.home>
	<20110809200842.GA29662@mac.home>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011 22:08:43 +0200
Tino Keitel <tino.keitel@tikei.de> wrote:

> On Wed, Aug 03, 2011 at 21:02:04 +0200, Tino Keitel wrote:
> 
> [...]
> 
> > Hi,
> > 
> > thanks for the patch. It works fine on top of 3.0. No more Oops at
> > boot, and the DVB-T receiver is working.
> > 
> > Regards,
> > Tino
> 
> Hi,
> 
> I didn't see the patch show up in git yet. This is a prerequisite to
> include it in 3.0.x AFAIK.
> 
> Regards,
> Tino

Yes, I pinged Mauro yesterday about it but didn't hear back. I remember
in the back of my head that Mauro uses patchwork on the linux-media
list, so that is where I will resend the patch... 

Regards,
Flo
