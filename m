Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0F1JgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:36:12 -0400
Received: from ozlabs.org ([203.10.76.45]:39545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab0F1JgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:36:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] ipmi: fix module param sparse warnings
Date: Mon, 28 Jun 2010 19:05:58 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Corey Minyard <minyard@acm.org>
References: <20100624152122.bfc0472a.randy.dunlap@oracle.com> <201006252220.17228.rusty@rustcorp.com.au> <4C24D779.6020209@oracle.com>
In-Reply-To: <4C24D779.6020209@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281905.59387.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 01:51:13 am Randy Dunlap wrote:
> On 06/25/10 05:50, Rusty Russell wrote:
> > On Fri, 25 Jun 2010 07:51:22 am Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> The <arg> parameter in module_param_cb() should be a pointer,
> > 
> > Well, I don't think there's anything wrong with it being a function.
> 
> Ah, yes, I see.  That makes it a sparse error, right?

Well, it's a weird corner case, but yes.

> > Meanwhile, we can do this instead.  Does it solve it as well?
> 
> Yes, that also fixes it.
> Thanks.

Thanks, I've added your tested-by.

Cheers,
Rusty.
