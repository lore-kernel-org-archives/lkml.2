Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0EIPTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:19:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44274 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EIPTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C3qbbf+fd0TifmYDb6nyaSdzKtM1qSea33MbiItzpE3cAXh5B2cIsFwpIlHfp66Xwk
         7G5XVMFqm4zyF4Of3FXk507r+M3rCGAZh1gq2p31OO1KH/Zzydx/6BGLlPZfbL601vr7
         eBvslomyHOvTXaJlpr8R4v1nKiRvzTI9YeEX0=
MIME-Version: 1.0
In-Reply-To: <20100509073842.5f593dd1@infradead.org>
References: <y2gf22d86811005071051q28a4fa84g2a3ea1a7ff487934@mail.gmail.com>
	 <j2if22d86811005082351x975e868foe1b40bf7a89e1448@mail.gmail.com>
	 <20100509073842.5f593dd1@infradead.org>
Date: Sun, 9 May 2010 20:49:33 +0530
Message-ID: <n2of22d86811005090819xdce574e5vd4b8c3d46cac14ff@mail.gmail.com>
Subject: Re: Link time manipulation of kernel symbols like read/write
From: "Leonidas ." <leonidas137@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> lkml is not rootkit-help-for-free ;-)

I promise that I am not going to write a root kit :-). But you gave me
a good start, I will
have to check some of the root kits in order to see how things happen there.

Actually, I want to see similarities between user space way of
linking/loading compared to
kernel space. Have not been able to figure out completely yet at
conceptual level. I have
gone through module.c file and insmod utility.

Any pointers to earlier such attempts would be helpful.

-Leo.
