Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0KBNtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:49:31 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:43236 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0KBNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:49:24 -0400
From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: 2.6.35->2.6.36 regression, vanilla kernel panic, ppp or hrtimers crashing
Date: Tue, 2 Nov 2010 15:49:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-git5-home1; KDE/4.4.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20101028070550.GA7647@ff.dom.local>
In-Reply-To: <20101028070550.GA7647@ff.dom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011021549.47466.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't try yet, but i enable more debugs and catch linked list corruption. 

Here is dumps from netconsole:
http://www.nuclearcat.com/ll.txt
http://www.nuclearcat.com/ll2.txt		

I have another PC, also fails to run 2.6.36, but netconsole don't give 
anything.
Both PC's have strange issue with clock drifting away too much (on 2.6.35 and 
maybe even before).


On Thursday 28 October 2010 10:05:50 Jarek Poplawski wrote:
> On 2010-10-25 11:22, Denys Fedoryshchenko wrote:
> > Hi
> > 
> > Here is what i got from netconsole
> > 
> >  [  259.238755] BUG: unable to handle kernel
> >  paging request
> >  at f8ba001c
> >  [  259.238953] IP:
> >  [<c0199ebe>] do_select+0x2cc/0x502
> 
> ...
> 
> > It is not easy to do full git bisect(it is semi-embedded distro), but i
> > can try reversing particular commits, if someone can give idea which
> > one, and can try debug patches.
> 
> Hi,
> Nothing concrete, but you might try reverting this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=commi
> tdiff;h=15fd0cd9a2ad24a78fbee369dec8ca660979d57e
> 
> Jarek P.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
