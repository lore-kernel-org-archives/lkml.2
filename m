Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0J0GUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:20:20 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:35526 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753250Ab0J0GUS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:20:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=f0buXcms1trcCpJFYmvQ8h8Q2I0LLzugVFQyFSpZdaPH9HwHuVa3kF6LlUUyEDa6w5907lNYpzYPujQeNfLvda/91bPZ7Ectlx7oYKfpJfX+52rcvQ3vhWuLxxGbp53AW7dTOmdW71a6Tqw5g2Du9vnROv+dtIrwGvIuPdBO3GQ=;
Message-ID: <882321.18802.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: GQ.XEUoVM1kcA0g.NVO1_EZxohSQq84OMMkDkq9NGoG58Fu
 1sLQ3CNIQMkaL.da7hksHEiFs8GxSG52O5aTMvhlViF_seVjBxvxkkoFJRzy
 XTDjN0qQbGli5.r1CgxXTFXdD6GVZjyOiHB0f.WITEoE04NC8WVvyhBeUggG
 Gk9wsGfCuq_ID4IBx8sjQ8LY56jEF3ma2bvmOeNaFWsAa58dDudpYHvGuBO3
 JtZO8BahJEfIeqIDaZYc9uuv_W.rWLx.USxAa38jsakfNf9RNSLKYE1ZAl2a
 Xbe_8s3QkPIZ7OJbgdEjvdLgztvTirdDQA5LRJ5a1wtUouZbHrsFxjA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Tue, 26 Oct 2010 23:20:16 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: memstick: Alternative approach to proposed fixes
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1288133739.15918.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> All the changes in this patchset are really minor and
> optional.
> I could have dropped them.

These are the only substantial fixes you patchset has. The rest of the
large submission is your unilateral decision to rewrite the whole thing
almost from scratch. I proposed, multiple times, to fix the small things
first, then discuss the long term evolution.

> 
> 
> I did much more that that.
> I made the memstick code readable so not only you could
> understand it
> I also wrote ms_block.c while adding common support.
> I made your code use that support.
> 
> It is really sad that you are doing that.
> 
> 
> 
> 


      
