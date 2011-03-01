Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1CAF0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:26:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47075 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAF0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eDuaK5OvDDnU9lrgTqI9T8gJr3f7I3jjbB/uOn2NpMVuyoYuK0JLZDsvLRwk5qLMpv
         s5er7p46ym2GG9LlnC2fp4LIPhjwSwG1Ge1jB2HuquxkwVN/gZCl2HRW9MipGwLgMsNS
         bXgsgmKBd/7tJrUBuOhTZqwDNtzB8qiQjGXLA=
Subject: Re: [PATCH v6] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
References: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298634040.2659.32.camel@edumazet-laptop>
	 <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 06:26:44 +0100
Message-ID: <1298957204.2676.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 13:20 +0800, Po-Yu Chuang a écrit :
> Hi Eric,
> 
> On Fri, Feb 25, 2011 at 7:40 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Both NIU and BENET refill rx ring after all packets receive work done,
> but I allocate rx buffer right after a packet is received. I think it
> is difficult
> to use a page for two rx buffers in my driver now. Can we just keep it
> the way it is? I can study how to achieve that after current driver is accepted.
> 

No problem, you are the author, I am only a reviewer and ask questions
after all ;)

Thanks !




