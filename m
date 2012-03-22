Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab2CVV2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:28:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40362 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965151Ab2CVV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:28:18 -0400
X-Sasl-enc: N8ReabFU5LtASFJoYLty65Q8ZQyuc+gNt4OOghJZMrMd 1332451697
Date: Thu, 22 Mar 2012 14:28:16 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan McCune <jonmccune@cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs binary attribute API flux
Message-ID: <20120322212816.GB30888@kroah.com>
References: <CAEwYmTJzzUi1qfRHYfZg77g1K7myNsAh2oDiY7hWxzRO5hQGHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEwYmTJzzUi1qfRHYfZg77g1K7myNsAh2oDiY7hWxzRO5hQGHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 04:38:46PM -0400, Jonathan McCune wrote:
> Greetings,
> 
> I maintain a Linux kernel module for a research project*, where it is
> necessary to move some binary data from userspace into the kernel.

What exact type of binary data are you talking about here?

> I
> have been using sysfs's 'struct bin_attribute'.  Unfortunately, every
> few kernel versions, my code breaks because of a change in the
> definition of some elements in this struct.  For example, kernel
> versions 2.6.20, 2.6.32, and 2.6.38 each define the 'read' and 'write'
> function pointers differently. I will spare the inline diff, but they
> can each be seen here:

Is this a problem?  It's only an issue for code that lives outside of
the kernel, and there's nothing we can do about that, sorry.

> My question: is there some other interface that I should be using?  Am
> I using sysfs incorrectly?  All of the documentation I've been able to
> find seems to strongly encourage the use of sysfs.

debugfs?

What exactly are you using this data for?  Who creates it?  What does it
represent?

thanks,

greg k-h
