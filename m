Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0K3O6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:58:51 -0500
Received: from kroah.org ([198.145.64.141]:38916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0K3O6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:58:50 -0500
Date: Tue, 30 Nov 2010 06:57:40 -0800
From: Greg KH <greg@kroah.com>
To: werner <w.landgraf@ru.ru>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: easycap needs  smp_lock.h, fixes build error
Message-ID: <20101130145740.GA11199@kroah.com>
References: <web-407197955@zbackend1.aha.ru>
 <20101122043520.GA10958@kroah.com>
 <20101121205626.4589e544.randy.dunlap@oracle.com>
 <20101121211311.05963007.randy.dunlap@oracle.com>
 <20101122194736.GA29830@kroah.com>
 <20101122121237.38cdd369.randy.dunlap@oracle.com>
 <web-413291852@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-413291852@zbackend1.aha.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 10:44:21AM -0400, werner wrote:
> HELLO
> 
> I dont believe this ... my 2.6.37-rc4 compilation gone bad again,
> because of the same error, and I have to recompile / re-package it,
> what needs some hours again ..  :(  :(
> 
>  The correction below worked on 2.6.37-rc3 (i.e. insert #include
> <linux/smp_lock.h>  into easycap_main.h)
> 
> 
> WHY THIS WASN'T PATCHED SINCE LONG TIME ?   Is the situation of the
> kernel developers similar bad like of the open office developers, so
> that they should be exchanged ???

This is fixed in Linux-next and will be going to Linus in a few days.

thanks,

greg k-h
