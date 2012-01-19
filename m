Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2ASJqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:46:08 -0500
Received: from seven.medozas.de ([188.40.89.202]:55532 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab2ASJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:46:04 -0500
Date: Thu, 19 Jan 2012 10:46:02 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Richard Weinberger <rw@linutronix.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: Netfilter: New target: RLOG
In-Reply-To: <1326965176.2249.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.LNX.2.01.1201191045530.27900@frira.zrqbmnf.qr>
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>  <20120119091248.GA32391@1984> <4F17E0A4.9040004@linutronix.de> <1326965176.2249.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2012-01-19 10:26, Eric Dumazet wrote:

>Le jeudi 19 janvier 2012 à 10:21 +0100, Richard Weinberger a écrit :
>
>> Yeah, I could add --ring, --ring-size and --add-timestamp to LOG.
>> What about a rlog_common.o which can be used by ipt_LOG and ip6t_LOG?
>> 
>
>or merge ipt_LOG and ip6t_LOG into xt_LOG ?

yes please :)
