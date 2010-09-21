Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0IUDnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 23:43:32 -0400
Received: from kroah.org ([198.145.64.141]:34788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0IUDnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 23:43:31 -0400
Date: Mon, 20 Sep 2010 20:43:14 -0700
From: Greg KH <greg@kroah.com>
To: liguozhu@huawei.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with debugfs
Message-ID: <20100921034314.GA14062@kroah.com>
References: <20100921022112.GA10336@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921022112.GA10336@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 10:21:12AM +0800, liguozhu@huawei.com wrote:
> Hi, there,
> 
> I do not know who is the maintainer for debugfs now.

Did it change?  It's always been me.  I guess I never created a
MAINTAINERS entry, is it really needed?

> But I think there is problem with its API: It uses filp->priv->mutex
> to protect the read/write (to the file) for the value of its
> attribute, but the mutex is not exported to the API user.  Therefore,
> there is no way to protect its value when you directly use the value
> in your module.

What is the problem here, could the value change somehow and you not
like that, or perhaps you read the wrong value from userspace?

Have an example of the issue somewhere?

thanks,

greg k-h
