Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2JKW7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:59:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63435 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2JKW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:59:21 -0400
Date: Thu, 11 Oct 2012 15:59:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <m27gqwtyu9.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com> <m27gqwtyu9.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Andi Kleen wrote:

> > While I've always thought SLUB was the default and recommended allocator,
> > I'm surprise to find that it's not always the case:
> 
> iirc the main performance reasons for slab over slub have mostly
> disappeared, so in theory slab could be finally deprecated now.
> 

SLUB is a non-starter for us and incurs a >10% performance degradation in 
netperf TCP_RR.
