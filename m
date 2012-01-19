Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2ASJ0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:26:31 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34549 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034Ab2ASJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:26:27 -0500
Message-ID: <1326965176.2249.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Netfilter: New target: RLOG
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Richard Weinberger <rw@linutronix.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Date: Thu, 19 Jan 2012 10:26:16 +0100
In-Reply-To: <4F17E0A4.9040004@linutronix.de>
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>
	 <20120119091248.GA32391@1984> <4F17E0A4.9040004@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 19 janvier 2012 à 10:21 +0100, Richard Weinberger a écrit :

> Yeah, I could add --ring, --ring-size and --add-timestamp to LOG.
> What about a rlog_common.o which can be used by ipt_LOG and ip6t_LOG?
> 

or merge ipt_LOG and ip6t_LOG into xt_LOG ?


