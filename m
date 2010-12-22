Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0LVIk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:40:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:50793 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0LVIk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:40:57 -0500
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>
In-Reply-To: <1293006589.2170.41.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 09:41:00 +0100
Message-ID: <1293007260.2170.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 09:29 +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 01:22 +0100, Miklos Vajna wrote:
> > Please let me know if you need more info.
> 
> What distro are you using? it looks like systemd is involved and I'm
> actively avoiding anything using that crap. It now triggering a bug
> means I need to get myself a 32bit image using it :/
> 
> If you happen to have a qemu image that reproduces.. :-)

Removed the systemd list from CC, please don't cross post with lists
that send bounces for non-members, that's considered rude.
