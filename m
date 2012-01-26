Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2AZQQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:16:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51903 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2AZQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:16:17 -0500
Message-ID: <1327594573.2500.55.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: iproute2-2.6.38 + oif argument error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ganesh Reddy K <ganeshreddyk@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, ganeshreddy <ganeshreddy@freescale.com>
Date: Thu, 26 Jan 2012 17:16:13 +0100
In-Reply-To: <1327594401.2500.53.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CA+h4rtFMtprNyW2GH601TY9gBY1JTWK+Wktka-RzD8MQogK+zQ@mail.gmail.com>
	 <1327521811.2605.8.camel@edumazet-laptop>
	 <CA+h4rtFmfa8=c7xXqcsG7emgnuozMQ2bqgziVMAfr11RHxJnRQ@mail.gmail.com>
	 <1327594401.2500.53.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 17:13 +0100, Eric Dumazet a écrit :
> Le jeudi 26 janvier 2012 à 21:30 +0530, Ganesh Reddy K a écrit :
> > uname -a output is
> > 
> > Linux P2020RDB 2.6.32 #32 SMP Tue Dec 6 16:21:38 IST 2011 ppc GNU/Linux
> 
> oif facility was added in 2.6.33 kernel
> 

If you need to backport this facility, check commit 1b038a5e60
(net 03/05: fib_rules: add oif classification)



