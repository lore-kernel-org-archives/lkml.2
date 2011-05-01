Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1EAKjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 06:39:10 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50333 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1EAKjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 06:39:07 -0400
Date: Sun, 1 May 2011 12:38:51 +0200
From: Florian Mickler <florian@mickler.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com
Subject: Re: [PATCH 0/5] get rid of on-stack dma buffers (part1)
Message-ID: <20110501123851.0ab6b799@schatten.dmk.lab>
In-Reply-To: <4DBC8D9C.2090802@redhat.com>
References: <1300657852-29318-1-git-send-email-florian@mickler.org>
	<20110430205405.4beb7d33@schatten.dmk.lab>
	<4DBC8D9C.2090802@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011 19:30:52 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Hi Florian,
> 
> Em 30-04-2011 15:54, Florian Mickler escreveu:
> > Hi Mauro!
> > 
> > I just saw that you picked up some patches of mine. What about these?
> > These are actually tested...
> 
> I'm still in process of applying the pending patches. Due to patchwork.kernel.org
> troubles (including the loss of about 270 patches from its SQL database only 
> recovered yesterday[1]), I have a long backlog. So, I'm gradually applying the remaing
> stuff. It will take some time though, and it will depend on patchwork mood, but I intend
> to spend some time during this weekend to minimize the backlog.
> 
> 
> Cheers,
> Mauro
> 
> [1] The recover lost the email's body/SOB, so I've wrote a script to use my email
> queue to get the data, using patchwork just to mark what patches were already
> processed. This increses the time I have to spend on each patch, as I need to run
> a script to match the patchwork patch with the patch ID inside my email queue.
> 

Ah ok, no time pressure over here.. just wanted to make sure
that these don't get lost.

Regards and thanks,
Flo
