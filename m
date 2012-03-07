Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2CGFRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:17:39 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63769 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab2CGFRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:17:37 -0500
Message-ID: <1331097450.2474.52.camel@edumazet-laptop>
Subject: Re: potential kernel bug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: l.a.y.3.r.2@gmail.com
Cc: linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Date: Tue, 06 Mar 2012 21:17:30 -0800
In-Reply-To: <4F56CA3E.1040405@gmail.com>
References: <4F56CA3E.1040405@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 mars 2012 à 18:38 -0800, l.a.y.3.r.2 a écrit :
> Hello,
> 
> I think I may have found a bug in the functionality of the kernel and
> iptables. I am concerned that it may be too sensitive to publicly
> disclose the exact details.
> 
> Can you please provide me with some guidance on how to provide
> additional details in a secure manner?
> 

Submit a mail to developers, and if you really believe a _high_ security
issue exists, to security@kernel.org

But you know, we fix such bugs every day...

List of involved people (if you want to stay private) : 

Pablo Neira Ayuso <pablo@netfilter.org>
David Miller <davem@davemloft.net>

You can add me too.


