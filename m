Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2BPGSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 01:18:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49594 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2BPGSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 01:18:08 -0500
Message-ID: <1329373082.5646.9.camel@edumazet-laptop>
Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "jcliburn@gmail.com" <jcliburn@gmail.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
Date: Thu, 16 Feb 2012 07:18:02 +0100
In-Reply-To: <C6B7BB6C-D1B8-4454-A2B2-558FCA5B0BBD@m3y3r.de>
References: <1329063403.1449.14.camel@localhost.localdomain>
	 <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com>
	 <1329204997.24837.15.camel@edumazet-laptop>
	 <1329366846.5646.1.camel@edumazet-laptop>
	 <C6B7BB6C-D1B8-4454-A2B2-558FCA5B0BBD@m3y3r.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 16 février 2012 à 07:13 +0100, Thomas Meyer a écrit :

> Hello Eric,
> 
> > 
> > Thomas, have you had the chance to test this patch ?
> 
> Yes, I'm running 3.2.6 with your patch applied for 3 days now. I didn't see above warning yet, but the warning was rather seldom, so I'll keep an eye on it in the next weeks.
> 
> Thanks for the patch!
> 

Thanks for testing !

Do have any idea of what could set skb mark to 1 on some packets on your
setup ?

Some firewall rules or tc rules ?



