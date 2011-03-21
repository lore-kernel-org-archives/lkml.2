Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1CUHzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 03:55:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48928 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1CUHzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 03:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jJwPzBVSU2AQ6FMzKC/0c3w3MfNE0S0EIwzTVF3p8MObCnzQgiwOJLhGHPbvA4b4cX
         sQM/s4UCa9/acEs1I3bbZlSHanNOXbgwOA3tBqOC9TRb3xu5IuYuG9cfk1uuvK8+Kbl/
         mi5ektpFnkkxyRLlii8vK+UHIdtq9OlxN9ZNU=
MIME-Version: 1.0
In-Reply-To: <1300361405.3133.175.camel@edumazet-laptop>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
 <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com>
 <1300357457.3133.92.camel@edumazet-laptop> <AANLkTino6LzGTZF4fNSkV9pbAfnmAc8wJjk0L8HfHDiJ@mail.gmail.com>
 <1300361405.3133.175.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Mon, 21 Mar 2011 15:54:41 +0800
Message-ID: <AANLkTinibrF_bJBbYwCSnGv1iD_9Dn7uBn2cqgcTrKHi@mail.gmail.com>
Subject: Re: [PATCH v2] net: add Faraday FTGMAC100 Gigabit Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Mar 17, 2011 at 7:30 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 17 mars 2011 à 18:56 +0800, Po-Yu Chuang a écrit :
>> On Thu, Mar 17, 2011 at 6:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le jeudi 17 mars 2011 à 17:47 +0800, Po-Yu Chuang a écrit :
>> >> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>> >>
>> >> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
>> >> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
>> >> including Faraday A369 and Andes AG102.
>> >>
>> >> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
>> >> ---
>> >
>> > Did you tried GRO support ?
>>
>> No, I don't understand how to do that yet. Let me do some study first.
>> I'd really appreciate it if you could provide me some pointers about GRO. :-)
>> Is there any document about it?
>
> Should be easy and might help performance too.
>
> Take a look at commit :
>
> 2edae08e5b75269855fef3c74fe4292c066e7c33 (r8169: add gro support)

It seems to work fine so far at least the driver is not broken, but I did not
see much difference in performance though. How do I know if GRO is
working indeed?

Best regards,
Po-Yu Chuang
