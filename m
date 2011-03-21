Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1CUFyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:54:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42622 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1CUFyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:54:14 -0400
Date: Mon, 21 Mar 2011 05:54:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc0: umount tmpfs hangs
Message-ID: <20110321055413.GT22723@ZenIV.linux.org.uk>
References: <AANLkTi=5pSyJVqOQUJ8wXbNpXogWcRdavswx9my0OzEX@mail.gmail.com>
 <20110321033926.GP22723@ZenIV.linux.org.uk>
 <AANLkTinKPfYdbAQWuzi5Wf-HadLfjT0hmDnMwJwkwf8N@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinKPfYdbAQWuzi5Wf-HadLfjT0hmDnMwJwkwf8N@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 08:30:23AM +0300, Alexander Beregalov wrote:

> > rcu_barrier() hanging for some reason... ??I really wonder what's going
> > on there - missing rcu_read_unlock()? ??Could you try to reproduce that
> > sucker and, if possible, bisect it?
> 
> Yes, it's reproducible, but I'm bisecting another issue and have few
> more such issues with the current kernel.

Could you post the reproducer?  Simple mounting tmpfs and umount explicitly
doesn't seem to trigger it; doing some IO on that fs doesn't change that,
ditto for umount done by shutdown instead of doing it manually...
