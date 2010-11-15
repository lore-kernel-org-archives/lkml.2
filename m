Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab0KOTS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:18:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51765 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab0KOTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=wnRoRy7pmVXkSgNNGILq9hfNVFQthJrau5jdz1OePqiujeGx30ZEF3BSwAi5Gqm4Xo
         SFHptVKDOzYWjDM45XQqSxZJQspq+cE2TM/fOQ267m+BUoIyu2fNL3qAQ5zSJ9DF/bKm
         LfA3Y+GeezrCfVQHp4gyM2b4C3P+t/8fpeXfg=
Date: Mon, 15 Nov 2010 22:18:51 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: jffs2: fix error value sign
Message-ID: <20101115191851.GA6450@albatros>
References: <1289765320-6071-1-git-send-email-segoon@openwall.com>
 <20101114202905.GA21614@bicker>
 <20101115143735.GA4548@albatros>
 <20101115184531.GA24643@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101115184531.GA24643@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 21:45 +0300, Dan Carpenter wrote:
> On Mon, Nov 15, 2010 at 05:37:37PM +0300, Vasiliy Kulikov wrote:
> > 
> > x86_64, linux-next:
> > 
> > make -C /home/vasya/linux fs/jffs2/xattr.o
> > make: Вход в каталог `/home/vasya/dev/linux-next'
>         ^^^^^^^^^^^^^^
> 
> This means "Entering directory" right?  So /home/vasya/linux is a
> symlink to /home/vasya/dev/linux-next.  It still compiles for me
> when I create a symlink and use the -C option...

Correct, but the same with cd ~linux/ && make fs/jffs2/xattr.o.

I've just updated to next-2010111 and it became compilable ;)
linux next is just very nonstable...

Thanks,

-- 
Vasiliy
