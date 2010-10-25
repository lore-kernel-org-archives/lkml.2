Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0JYOkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:40:06 -0400
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:34402 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756213Ab0JYOkB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:40:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SqN4bW5WTdTi/9FndsHhvktATjp7/l1uKOhRoTeE9UJhgztpJ9BLomKVxECRW9y0B4XXUwvHa3V+NxnASoPleezoWXEQcq63YjPSw9efcw7fdZJHyeciTqRfg6E37AIIcVRYOkrgbyFFgjKVFO/68AdJkepAH8js5Kz8Cg+B4sU=;
Message-ID: <408703.12417.qm@web37603.mail.mud.yahoo.com>
X-YMail-OSG: SvDyFMwVM1kLQe5XLxiPyrOUG68MaMGHwyjRL9GJ9ltCsET
 K6qiSSgDkCD4cDoD2NVgSDK8HAvvAyUkWlU0nu.f0HK4yiIUol85uZijVj_y
 oa6u7kLf.eTGMxzl8QL6uCk7hZY3WuruH7XfCdokmXm2OaOxcWAhEEdG5IRw
 RMXVpc6wHAnMzEyyCzfu3_hLrwDTVKz_kqRm.dFX.Wn6AOlyYJYM3uv9x9Pi
 keTUookpeO5fLhIMdOp5Td5TtXumy2K88UQzoqw7YU1PzJJK2XMTMGRWQyEj
 rVLR0drdV5LpqREFlSPxedQneb0WdJHA45RGpIwl1LI7coPR.vghYOWhRLxv
 tR4SqMsvH
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 07:39:58 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 0/29] My patch queue for memorystick subsystem
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287972070.5205.12.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sun, 24/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> > 

> Any update?
> Can I expect this in 2.6.37?
> 

If I understand the process correctly, probably no. It's going to take more
time, considering the volume and nature of changes.

There's also additional very unfortunate property of your patchset, namely
you're mixing purely cosmetic and functional patches. Normally, functional
patches should precede the cosmetic one, so that the functionality can be
discussed first.


      
