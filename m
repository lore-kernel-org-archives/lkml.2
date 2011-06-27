Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1F0PYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1F0PYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:24:34 -0400
Message-ID: <4E08A0A0.1080409@redhat.com>
Date: Mon, 27 Jun 2011 12:24:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl  doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <201106262020.20432.arnd@arndb.de>	 <4E077FB9.7030600@redhat.com> <201106270738.27417.hverkuil@xs4all.nl>	 <20110627120233.GD12671@valkosipuli.localdomain>	 <86e5c1f0a0222d3b2cf371f3c9d3b067.squirrel@webmail.xs4all.nl>	 <4E088B83.2050001@redhat.com> <1309187569.3559.63.camel@morgan.silverblock.net>
In-Reply-To: <1309187569.3559.63.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2011 12:12, Andy Walls escreveu:
> On Mon, 2011-06-27 at 10:54 -0300, Mauro Carvalho Chehab wrote:
> 
>> The right thing to do is to create a separate chapter for error codes, based on errno(3)
>> man page [snip]
> 
> IMO, the IEEE Std 1003.1 is a better source for errno definitions than
> the errno(3) manpage:
> 
> http://pubs.opengroup.org/onlinepubs/000095399/functions/xsh_chap02_03.html

True, but it doesn't cover all error types. For sure we need to use the POSIX standard
when working at the DocBook.

Cheers,
Mauro
