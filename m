Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2HECKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 22:10:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64934 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2HECKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 22:10:07 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 4 Aug 2012 19:10:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kumar Sukhani <kumarsukhani@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: Linux kernel boot process
Message-ID: <20120805021006.GA22851@roeck-us.net>
References: <CALNeL8XsBQyD_QwQU3e4B9Bj36rABr5LKC7q9rxEE=dQ-Z2F4w@mail.gmail.com>
 <CALNeL8UwX4bEqXE12mRX4xdSNW3MF4iU6+GN0moi=w7DT0mUZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALNeL8UwX4bEqXE12mRX4xdSNW3MF4iU6+GN0moi=w7DT0mUZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 12:57:55PM +0530, Kumar Sukhani wrote:
> I heard that windows 8 have change its boot process to a hybrid mood.
> In which it shutdowns the user applications and hibernates the kernel
> and device drivers[1].
> Can the same be introduce in Linux kernel?
> 
> [1]  http://www.zdnet.com/windows-8-hybrid-mode-brings-faster-boot-3040093896/
> 
What would be the point ? Linux already boots much faster than Windows, even
with Windows running in "hybrid" mode. And, from what I heard, things will get
even better with systemd.

Guenter
