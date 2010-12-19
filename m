Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0LSOoC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:44:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0LSOoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:44:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heinz Diehl <htd@fritha.org>
Subject: Re: [Bug #19632] 2.6.36-rc6: modprobe Not tainted warning
Date: Sun, 19 Dec 2010 15:42:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera> <xqq2Z3iR9HJ.A.1bH.l2fDNB@chimera> <20101219135449.GA13734@fritha.org>
In-Reply-To: <20101219135449.GA13734@fritha.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012191542.57431.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 19, 2010, Heinz Diehl wrote:
> On 19.12.2010, Rafael J. Wysocki wrote: 
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19632
> > Subject		: 2.6.36-rc6: modprobe Not tainted warning
> > Submitter	: Heinz Diehl <htd@fritha.org>
> > Date		: 2010-09-30 18:25 (81 days old)
> > Message-ID	: <20100930182516.GA15089@fritha.org>
> > References	: http://marc.info/?l=linux-kernel&m=128587114004680&w=2
> 
> There's a fix pending which should have made it into 2.6.37:
> https://patchwork.kernel.org/patch/240661/
> 
> At least, it fixes the problem for me.

This patch is in the current Linus' tree.  Closing.

Thanks,
Rafael
