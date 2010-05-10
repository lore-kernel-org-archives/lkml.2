Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0EJVeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab0EJVeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:34:36 -0400
Date: Mon, 10 May 2010 23:34:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
In-Reply-To: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz>
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, Justin Mattock wrote:

> is it me, or is there something wrong
> with the magicmouse connecting
> i.g. I've had my system setup to use the
> magicmouse with 2.6.33* with no issues
> now coming back after sometime
> seems everything is connecting,but then no movement:
> (and some thing in dmesg):
> [  116.267993] magicmouse 0005:05AC:030D.0007: claimed by neither
> input, hiddev nor hidraw
> [  116.268053] magicmouse 0005:05AC:030D.0007: magicmouse hw start failed
> 
> using osx  magicmouse connects fine.
> Using standard mightymouse everything connects.
>  are there any reports of such things?

Adding Michael Poole to CC.
                                                                                                                                              
No, I haven't seen any such reports. First -- could you please provide 
complete dmesg?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

