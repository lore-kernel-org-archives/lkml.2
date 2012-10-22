Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2JVX4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:56:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2JVX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:56:04 -0400
Date: Mon, 22 Oct 2012 16:56:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stefani Seibold <stefani@seibold.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove untouched code in kfifo_in
Message-Id: <20121022165602.41c4953e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1210190934010.7523@pobox.suse.cz>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
	<CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
	<1350624189.14741.1.camel@wall-e>
	<alpine.LNX.2.00.1210190934010.7523@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 09:34:43 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 19 Oct 2012, Stefani Seibold wrote:
> 
> > > > In kfifo_in marco, one piece of code is arounded by if(0). This code in
> > > > introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
> > > > warning. This warning is not there with the upgrade of gcc version.
> > > >
> > > > This patch just remove this code.
> > > 
> > > Are you sure?
> > > This code fragment looks like a compiler bomb to detect type mismatch to me...
> > 
> > Yes, you are great! That was the reason why i made this peace of code.
> > So don't remove it!
> 
> As even you, the author of the code, got confused by it for a while, 
> adding an explanatory comment seems appropriate.
> 

include/linux/typecheck.h?
