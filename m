Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab1EQW6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:58:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50371 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab1EQW6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QtHW4sXgj6cDWMcawkzBxA0EUHUkaiJJOExJVPMJeYMOZdVidAGQajmWAiBNlvtdd7
         WNGkkl+1gEAez+OeFOkSGieGgGR2b5SgzQavIy/4FXHQmzs+ddI6CzGm0vhY7E92b2D5
         UftXCX7pvLfLLetRoMpUewsy8EBQPvgDvrOXU=
MIME-Version: 1.0
In-Reply-To: <1305671318.10756.49.camel@localhost.localdomain>
References: <1305574128.3456.23.camel@localhost.localdomain>
 <1305574518.2885.25.camel@bwh-desktop> <1305574680.3456.33.camel@localhost.localdomain>
 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
 <1305588738.3456.65.camel@localhost.localdomain> <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
 <1305671318.10756.49.camel@localhost.localdomain>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 18 May 2011 00:58:00 +0200
Message-ID: <BANLkTik6aqP5BVrQNFKrnU3v=KA9ip1RoA@mail.gmail.com>
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in netdevice
To: Shirley Ma <mashirle@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18 maja 2011 00:28 u¿ytkownik Shirley Ma <mashirle@us.ibm.com> napisa³:
> On Tue, 2011-05-17 at 23:48 +0200, Micha³ Miros³aw wrote:
>> 2011/5/17 Shirley Ma <mashirle@us.ibm.com>:
>> > Looks like to use a new flag requires more time/work. I am thinking
>> > whether we can just use HIGHDMA flag to enable zero-copy in macvtap
>> to
>> > avoid the new flag for now since mavctap uses real NICs as lower
>> device?
>>
>> Is there any other restriction besides requiring driver to not recycle
>> the skb? Are there any drivers that recycle TX skbs?
> Not more other restrictions, skb clone is OK. pskb_expand_head() looks
> OK to me from code review.

> Currently there is no drivers recycle TX skbs.

So why do you require the target device to have some flags at all?

Do I understand correctly, that this zero-copy feature is about
packets received from VMs?

Best Regards,
Micha³ Miros³aw
