Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2DOKxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:53:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34622 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752366Ab2DOKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:53:18 -0400
X-Authenticated: #18353093
X-Provags-ID: V01U2FsdGVkX1+O+7QEdjGOi6qAd8wFnW2mJqz9wrhje4IyDna5i6
	CnCgZppaGIYpis
Message-ID: <4F8AA8AC.8070304@gmx.de>
Date: Sun, 15 Apr 2012 12:53:32 +0200
From: Karl Herz <karl.herz@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Workaround for ASM108X interrupt problem (nobody cared ...)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My VDR system (ASUS P8H67-V) is running stable with 3 PCI cards (2 DVB, 
1 network)
by using the following kernel options:  noirqdebug irqpoll

This seems to work as
- With noirqdebug the interrupts are not disabled (and the ASM108X 
interrupt bursts stop after some time).
- With irqpoll the interrupts with lower priority than the ASM108X 
interrupts are handled in time.

I hope this workaround helps to get also some other systems running 
stable with PCI cards.

Karl

