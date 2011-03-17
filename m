Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1CQLaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:30:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39824 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1CQLaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RK+r8BUfYY7UvZNue9QoS2Rc2wekyH7GXZtyullqH7iOH1rbJ/wErENBwma8MVpyqB
         QmnWcvGvMt8XWoVtOnI45doVKAVfkNntiR8askvVgkAfOfmRI/5UuKv1x0XDVkQWijuo
         312gpkiLrTnHBIwN1HcabzacYCalt2teQaDnM=
Subject: Re: [PATCH v2] net: add Faraday FTGMAC100 Gigabit Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com
In-Reply-To: <AANLkTino6LzGTZF4fNSkV9pbAfnmAc8wJjk0L8HfHDiJ@mail.gmail.com>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300357457.3133.92.camel@edumazet-laptop>
	 <AANLkTino6LzGTZF4fNSkV9pbAfnmAc8wJjk0L8HfHDiJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 12:30:05 +0100
Message-ID: <1300361405.3133.175.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 18:56 +0800, Po-Yu Chuang a écrit :
> Hi Eric,
> 
> On Thu, Mar 17, 2011 at 6:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le jeudi 17 mars 2011 à 17:47 +0800, Po-Yu Chuang a écrit :
> >> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> >>
> >> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
> >> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
> >> including Faraday A369 and Andes AG102.
> >>
> >> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> >> ---
> >
> > Did you tried GRO support ?
> 
> No, I don't understand how to do that yet. Let me do some study first.
> I'd really appreciate it if you could provide me some pointers about GRO. :-)
> Is there any document about it?

Should be easy and might help performance too.

Take a look at commit :

2edae08e5b75269855fef3c74fe4292c066e7c33 (r8169: add gro support)


