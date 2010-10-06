Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0JFAVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587Ab0JFAVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:21:54 -0400
Subject: Re: System freeze on shutdown - bisected to commit 29d08b3efddc
From: Dave Airlie <airlied@redhat.com>
To: Marc Dionne <marc.c.dionne@gmail.com>, Ben Skeggs <skeggsb@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikBXb-QZ2twFUZHzzYSHyZz1Kca4GRLu_6bo+Oo@mail.gmail.com>
References: <AANLkTikBXb-QZ2twFUZHzzYSHyZz1Kca4GRLu_6bo+Oo@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 10:21:49 +1000
Message-ID: <1286324509.2505.0.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 18:24 -0400, Marc Dionne wrote:
> Hi,
> 
> My system has been crashing these past few days when issuing "reboot"
> or hitting the Shut Down button in gnome.  I get a series of stack
> traces scrolling on the console before things freeze up completely.
> The traces that I do see at the end point to kmem_cache_alloc called
> from get_empty_filp, but there are typically various other traces
> above it.

cc'ing Ben.

Dave.

> 
> It is easily reproducible so I took the time today to bisect it down
> to this recent commit:
>    29d08b3efddca628b0360411ab2b85f7b1723f48
>    drm/gem: handlecount isn't really a kref so don't make it one
> 
> Reverting the commit on top of current git fixes the problem.  The
> system has an Nvidia card and loads the nouveau driver.  Current
> .config is attached.
> 
> Marc


