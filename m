Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1FZMmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:42:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54653 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1FZMme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Wlydq4HaB8keuBBh931wgsGj3KyQ5pTtw0ima561BICV/oy5brjlYKFaENzLppdeeZ
         b8cfxWKULFY5jYQ4tDZbZFgDVGjBJLrBgHbvhy83iUkyUQ3Yyar7zEbK5I7v+SGOr5AJ
         rdzjN/wg2A6UQJJFvghoMcGMjxB9FS0mDlE44=
Subject: Re: 2.6.39.2 BUG: unable to handle kernel NULL pointer dereference
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikhGVYAFEZGS-AZf3CyS4yVN+Acvg@mail.gmail.com>
References: <BANLkTing9LWO6AjbdzOJzkJ9aoJhn_TLnw@mail.gmail.com>
	 <1309082172.2532.31.camel@edumazet-laptop>
	 <BANLkTikhGVYAFEZGS-AZf3CyS4yVN+Acvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Jun 2011 14:42:27 +0200
Message-ID: <1309092147.2532.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 26 juin 2011 à 13:34 +0200, Fabio Coatti a écrit :
> 2011/6/26 Eric Dumazet <eric.dumazet@gmail.com>:
> > Le dimanche 26 juin 2011 à 10:28 +0200, Fabio Coatti a écrit :
> >> I'm trying to boot with 2.6.39.2 but the process stops somewhere in
> >> network stack, with a BUG: report.
> >> I've been able to capture the kernel messages usign netconsole, so be
> >> patient with poor alignment :)
> 
> >
> > Hi Fabio
> >
> > Could you test following patch :
> >
> > http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6407d74c5106bb362b4087693688afd34942b094
> >
> >
> > This should be included in 2.6.39.3, if you confirm this fixes the
> > problem.
> >
> 
> Yes, I can confirm that your patch fixes the problem, now running
> 2.6.39.2 just fine. Many thanks!

Thanks for testing, David will include this to his stable queue I
presume.



