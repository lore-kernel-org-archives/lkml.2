Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2BPGYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 01:24:32 -0500
Received: from www17.your-server.de ([213.133.104.17]:36706 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab2BPGYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 01:24:30 -0500
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Feb 2012 01:24:30 EST
References: <1329063403.1449.14.camel@localhost.localdomain> <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com> <1329204997.24837.15.camel@edumazet-laptop> <1329366846.5646.1.camel@edumazet-laptop> <C6B7BB6C-D1B8-4454-A2B2-558FCA5B0BBD@m3y3r.de> <1329373082.5646.9.camel@edumazet-laptop>
In-Reply-To: <1329373082.5646.9.camel@edumazet-laptop>
Mime-Version: 1.0 (iPod Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <21390AB8-BD9B-44D7-B2CE-B20AF7605CE7@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "jcliburn@gmail.com" <jcliburn@gmail.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
X-Mailer: iPod Mail (8C148)
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Date: Thu, 16 Feb 2012 07:23:52 +0100
To: Eric Dumazet <eric.dumazet@gmail.com>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.02.2012 um 07:18 schrieb Eric Dumazet <eric.dumazet@gmail.com>:

> Le jeudi 16 février 2012 à 07:13 +0100, Thomas Meyer a écrit :
> 
>> Hello Eric,
>> 
>>> 
>>> Thomas, have you had the chance to test this patch ?
>> 
>> Yes, I'm running 3.2.6 with your patch applied for 3 days now. I didn't see above warning yet, but the warning was rather seldom, so I'll keep an eye on it in the next weeks.
>> 
>> Thanks for the patch!
>> 
> 
> Thanks for testing !
> 
> Do have any idea of what could set skb mark to 1 on some packets on your
> setup ?

No idea.

> 
> Some firewall rules or tc rules ?

I'm using a fedora 16 installation. No big changes made on the configuration.

The warning seems to occur only when shutting down the remote computer.

> 
> 
> 
