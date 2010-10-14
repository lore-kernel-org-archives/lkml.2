Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0JNFOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 01:14:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52736 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0JNFOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 01:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nQEiuqdvyA4VtcYDTkrmnUWpzKn2OC3IDHvKiYFCTeoW/0mPjmPcYYxJxqK0CCZbkk
         SnYx6GTWBURk5ZLJXrlwrKAFJbbGvWpSTveMPfeCeDUWKY/S5c+z7eqPYDD0AB7beNI8
         zXhkjj4wB0Y+YMdd/qwtbyTe7B7F37SqUAkAk=
Date: Thu, 14 Oct 2010 13:18:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: gaoqiang <834555262@qq.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dear list
Message-ID: <20101014051833.GA5167@cr0.nay.redhat.com>
References: <4C7F4984.1060703@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7F4984.1060703@qq.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 02:51:48PM +0800, gaoqiang wrote:
>I'm a newbie and got some question when learning the linux kernel
>
>about a macro:
>
>page_to_pfn(pg)
>
>I traced its definition,and finally got that:
>
>#define __page_to_pfn(page) ((unsigned long)((page) - mem_map) +
>ARCH_PFN_OFFSET)
>
>
>why hot ((unsigned long)((page)-mem_map + ARCH_PFN_OFFSET)/sizeof
>(struct page)
>

Sorry for the really long delay.

That is because both 'page' and 'mem_map' have type 'struct page *'.
