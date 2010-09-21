Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0IUEi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:38:27 -0400
Received: from xenotime.net ([72.52.115.56]:60986 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751347Ab0IUEi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:38:26 -0400
Date: Mon, 20 Sep 2010 21:38:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: liguozhu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: Problem with debugfs
Message-Id: <20100920213825.72ac1a92.rdunlap@xenotime.net>
In-Reply-To: <20100921034314.GA14062@kroah.com>
References: <20100921022112.GA10336@localhost>
	<20100921034314.GA14062@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 20:43:14 -0700 Greg KH wrote:

> On Tue, Sep 21, 2010 at 10:21:12AM +0800, liguozhu@huawei.com wrote:
> > Hi, there,
> > 
> > I do not know who is the maintainer for debugfs now.
> 
> Did it change?  It's always been me.  I guess I never created a
> MAINTAINERS entry, is it really needed?


We shouldn't assume that everyone uses git and can then use
./scripts/get_maintainer.pl.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
