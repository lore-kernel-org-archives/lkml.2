Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1EJFPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:15:53 -0400
Received: from mail.perches.com ([173.55.12.10]:1441 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1EJFPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:15:52 -0400
Subject: Re: [PATCH]Add Maintainer for MAINTAINERS file for us
From: Joe Perches <joe@perches.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, greg@kroah.com, linux-doc@vger.kernel.org
In-Reply-To: <20110510045142.GA2888@gmail.com>
References: <20110510025024.GA2575@gmail.com>
	 <1304997087.19586.102.camel@Joe-Laptop>  <20110510045142.GA2888@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 22:15:50 -0700
Message-ID: <1305004550.19586.114.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 12:51 +0800, Harry Wei wrote:
> On Mon, May 09, 2011 at 08:11:27PM -0700, Joe Perches wrote:
> > On Tue, 2011-05-10 at 10:50 +0800, Harry Wei wrote:
> > > I'd like to maintain this file for us. The patch is below.
> > Knock yourself out, but I think this won't
> > be too valuable.
> The patch has been updatated below.
[]
> This may a little complex. Keeping just MAINTAINERS file
> with alphabetical order is well for us.
> I will also write a shell script for MAINTAINERS, which
> can not only check whether it is in alphabetical order
> but may also take orders for us.
> The script is been programing by me and my friend.
> When it is okay, i will patch for kernel.

I believe that's been done before.

http://lkml.org/lkml/2011/2/11/330

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> +MAINTAINERS-FILE
> +M:	Harry Wei <harryxiyou@gmail.com>
> +L:	linux-doc@vger.kernel.org
> +S:	Maintained
> +F:	MAINTAINERS

I think using the linux-doc mailing list for
MAINTAINERS isn't good.

