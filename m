Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1J3W30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 18:29:26 -0400
Received: from smtprelay0230.b.hostedemail.com ([64.98.42.230]:37619 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753021Ab1J3W3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 18:29:25 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1767
Date: Sun, 30 Oct 2011 22:29:23 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <1179048211.51348.1320013764432.JavaMail.mail@webmail17>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030151256.27b2b20e@infradead.org>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.147.51.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Oct 31, 2011, Arjan van de Ven wrote:
>
> On Sun, 30 Oct 2011 19:57:12 +0000 (GMT)
> "Artem S. Tashkinov" wrote:
>
> > Hello,
> >
> > It's known that if you want to reach maximum performance on HT
> > enabled Intel CPUs you should distribute the load evenly between
> > physical cores, and when you have loaded all of them you should then
> > load the remaining virtual cores.
>
> this is a bold statement, and patently false if you have to threads of
> one process that heavily share data between eachother...
> (but true for more independent workloads)

In my initial message I was talking about completely unrelated tasks/
processes which share no data/instructions/whatever else. You don't
need to trust my test case as you can carry out this test on your own.

I have asked quite a lot of people to do that and a lot of them see this
unfortunate pattern. 
