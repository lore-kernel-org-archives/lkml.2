Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab1KRNyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:54:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab1KRNy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:54:29 -0500
Message-ID: <1321624465.3277.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: routing bug?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Pozs=E1r_Bal=E1zs?= <pozsy@uhulinux.hu>
Cc: Sven-Haegar Koch <haegar@sdinet.de>,
        Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Tam=E1si_J=E1nos?= <janusz@uhulinux.hu>,
        netdev@vger.kernel.org
Date: Fri, 18 Nov 2011 14:54:25 +0100
In-Reply-To: <4EC65FF1.9010601@uhulinux.hu>
References: <4EC648C9.8080405@uhulinux.hu>
			 <alpine.DEB.2.02.1111181346480.17023@aurora>
		 <1321621796.3277.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
		 <4EC65C4B.6050505@uhulinux.hu>
	 <1321623207.3277.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EC65FF1.9010601@uhulinux.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 novembre 2011 à 14:38 +0100, Pozsár Balázs a écrit :

> Unfortunately it does not solve the problem for me, I have have these 
> "cache <redirected>" entries even after that echo command.
> 

Its a problem with a cached value.

You must reboot to flush it.

It was already discussed yesterday on netdev.


