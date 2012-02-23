Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2BWIyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:54:22 -0500
Received: from www17.your-server.de ([213.133.104.17]:42253 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2BWIyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:54:17 -0500
Message-ID: <20120223095407.16803qant5u4yoxb@webmail.your-server.de>
Date: Thu, 23 Feb 2012 09:54:07 +0100
From: Thomas Meyer <thomas@m3y3r.de>
To: Ian Kent <raven@themaw.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: compat: autofs v5 packet size ambiguity - update
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net>
 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net>
 <1329890027.2193.48.camel@perseus.themaw.net>
 <1329890251.2193.50.camel@perseus.themaw.net>
 <1329903139.2193.66.camel@perseus.themaw.net>
 <CA+55aFwkYkSC1O=fWtj1CBAeKDP-ogEL4Mai8U-dd2uCMArppw@mail.gmail.com>
 <1329961703.2244.8.camel@perseus.themaw.net>
 <1329962085.2244.10.camel@perseus.themaw.net>
 <1329963683.2244.19.camel@perseus.themaw.net>
In-Reply-To: <1329963683.2244.19.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Ian Kent <raven@themaw.net>:

> On Thu, 2012-02-23 at 09:54 +0800, Ian Kent wrote:
>> On Thu, 2012-02-23 at 09:48 +0800, Ian Kent wrote:
>>
>> On second thought, I suppose other user space users don't "have" to use
>> mount(2) ....
>
> Thomas, what does systemd use to mount the autofs mounts that it uses?
>

Judging from  
http://cgit.freedesktop.org/systemd/systemd/tree/src/automount.c#n515  
- mount is called via library/system call.


