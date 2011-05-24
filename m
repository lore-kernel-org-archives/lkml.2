Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab1EXSmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:42:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60985 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab1EXSmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:42:42 -0400
Date: Tue, 24 May 2011 14:42:38 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] ARM Device tree support
In-Reply-To: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1105241435550.3207@xanadu.home>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Grant Likely wrote:

> Hi Russell,
> 
> How do you want to handle merging the ARM DT support?  Do you want to
> pull it into your tree, or would you like me to ask Linus to pull
> directly?  As you can see, It does include a couple of pre-requisite
> cross-arch cleanups that I normally push to Linus directly.

I don't think that Linus would object to you pushing that to him 
directly, given that Russell has already agreed to those patches going 
in this cycle.

Whatever the path, it is however important that they do get in _this_ 
cycle.  Most people are just too nervous committing themselves to DT if 
the basic stuff doesn't hit mainline.  And if we are serious about 
_trying_ to change the state of things in ARM land by going the DT route 
then we must have this in mainline as soon as possible.


Nicolas
