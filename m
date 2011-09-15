Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab1IOSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:05:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46018 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277Ab1IOSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:05:22 -0400
Subject: Re: [PATCH] sys_poll(): fix function definition/negative timeout
 values
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m27h59g0k7.fsf@firstfloor.org>
References: <1316090761.6545.70.camel@localhost.localdomain>
	 <m27h59g0k7.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 20:05:17 +0200
Message-ID: <1316109917.2492.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 10:47 -0700, Andi Kleen a écrit :
> Thomas Meyer <thomas@m3y3r.de> writes:
> 
> > Fix negative timeout values for x86 userland on x86_64 kernels.
> > Align sys_poll() definition to glibc's definition.
> 
> Nack. Please write a compat wrapper that sign extends.
> 

Why ?

man poll

int poll(struct pollfd *ufds, unsigned int nfds, int delay); 




