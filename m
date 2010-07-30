Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0G3J7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:59:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54128 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab0G3J7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=WJw2hNmu/EO7FS4iANoXKi1CPXb+oHJ+gD54eQS+1FCPv4DOMp+P26FCu6pO8cKxu8
         99m01yZHABG+Vq8FE/9DrWIU1LCl6F6NzL64HaP168z4gy4IE3Xd+SFrYw1X9t8e7HvA
         5d5YgOwIssy9uKKTUzbSbNKu3ovdXNKXAu5Jw=
Date: Fri, 30 Jul 2010 18:03:51 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?B?0JPRg9GA0LDQvCDQodCw0LLQuNC90L7Qsg==?= 
	<savinov.guram@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Get interface MAC address in sys_accept4() syscall
Message-ID: <20100730100351.GC5638@cr0.nay.redhat.com>
References: <4C5211D6.3000406@gmail.com>
 <20100730071617.GA5638@cr0.nay.redhat.com>
 <AANLkTi=bSLALO0xP3kWgX9ipRBroDsqzXp6=kPuwMtW2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=bSLALO0xP3kWgX9ipRBroDsqzXp6=kPuwMtW2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 01:56:06PM +0400, Гурам Савинов wrote:
>I want to change syscall sys_accept4(), to return MAC address.
>It is possible to get MAC from incomming socket in sys_accept4(), with help
>ioctl SIOCGIFHWADDR?
>

The problem is that it doesn't make sense to do this.

accept(2) works on high level sockets, should not bother low level
MAC addresses.

