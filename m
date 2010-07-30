Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0G3KW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:22:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53713 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0G3KW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qbDVkEJwQz2kHq53JT5sUPaQbtdAJyrTpqX90AcsarCn2Orbe+KbsWchQVIHk0u86R
         /RuhT9pCprSH3GHu8fzD7SX7AxO2XaJZMXSnMX+oEIUCO3nBVm9mxefqbrUXWdPWYDzt
         e5yOF8Jq2N8sCpfVWCNk3GT4plE7rKCre0nZU=
MIME-Version: 1.0
In-Reply-To: <20100730100351.GC5638@cr0.nay.redhat.com>
References: <4C5211D6.3000406@gmail.com>
	<20100730071617.GA5638@cr0.nay.redhat.com>
	<AANLkTi=bSLALO0xP3kWgX9ipRBroDsqzXp6=kPuwMtW2@mail.gmail.com>
	<20100730100351.GC5638@cr0.nay.redhat.com>
Date: Fri, 30 Jul 2010 14:22:55 +0400
Message-ID: <AANLkTin8vaiWTRTM+WzZ_PAWO6j-voP29n1jHfLv+=q3@mail.gmail.com>
Subject: Re: Get interface MAC address in sys_accept4() syscall
From: "Guram Z. Savinov" <savinov.guram@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I know, but sys_accept4() have int fd argument, that is socket
descriptor, can I work with it like raw socket and get MAC from
ethernet frame?

2010/7/30 Américo Wang <xiyou.wangcong@gmail.com>
>
> On Fri, Jul 30, 2010 at 01:56:06PM +0400, Гурам Савинов wrote:
> >I want to change syscall sys_accept4(), to return MAC address.
> >It is possible to get MAC from incomming socket in sys_accept4(), with help
> >ioctl SIOCGIFHWADDR?
> >
>
> The problem is that it doesn't make sense to do this.
>
> accept(2) works on high level sockets, should not bother low level
> MAC addresses.
>
