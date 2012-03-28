Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2C1UID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:08:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61013 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1UIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:08:01 -0400
MIME-Version: 1.0
In-Reply-To: <1332946113.2325.9.camel@edumazet-glaptop>
References: <1332882712-10756-1-git-send-email-alex.mihai.c@gmail.com>
	<20120328105212.1cb8dfe5@asterix.rh>
	<1332946113.2325.9.camel@edumazet-glaptop>
Date: Wed, 28 Mar 2012 23:08:00 +0300
X-Google-Sender-Auth: av4ChPVgyJPxCV69wcIumuskiOA
Message-ID: <CAEnQRZD+0AQFfFCzWZCR5JR0BUxxNEsincD+_O9F0ne2Zryp_w@mail.gmail.com>
Subject: Re: [PATCH] tcp: bind() use stronger condition for bind_conflict
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, Flavio Leitner <fbl@redhat.com>
Cc: Alexandru Copot <alex.mihai.c@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 5:48 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2012-03-28 at 10:52 -0300, Flavio Leitner wrote:
>> On Wed, 28 Mar 2012 00:11:52 +0300
>> Alexandru Copot <alex.mihai.c@gmail.com> wrote:
>>
>
>> > diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
>> > index 02dd203..dfc8bc3 100644
>> > --- a/net/ipv6/inet6_connection_sock.c
>> > +++ b/net/ipv6/inet6_connection_sock.c
>> > @@ -28,7 +28,8 @@
>> >  #include <net/inet6_connection_sock.h>
>> >
>> >  int inet6_csk_bind_conflict(const struct sock *sk,
>> > -                       const struct inet_bind_bucket *tb)
>> > +                       const struct inet_bind_bucket *tb,
>> > +                           int relax)
>>
>> Same here
>> Maybe you can wait for more feedbacks before spin another patch
>> version just to fix that.
>>
>
>
>
> Also 'int relax' should be 'bool relax'... 1/0 -> true/false
>
> Anyway net-next is not open yet...

Eric, Flavio, thanks a lot for your comments. We will resubmit this
when net-next opens.

Please let us know if you have any other observations.

thanks,
Daniel.
