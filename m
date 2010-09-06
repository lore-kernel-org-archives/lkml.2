Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0IFLAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:00:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48148 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0IFLAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:00:15 -0400
Date: Mon, 6 Sep 2010 13:00:13 +0200
From: Florian Mickler <florian@mickler.org>
To: Doug Nazar <nazard.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        paulmck@linux.vnet.ibm.com
Subject: Re: [Bug #17131] WARN with 3c905 boomerang NIC
Message-ID: <20100906130013.226b6471@schatten.dmk.lab>
In-Reply-To: <4C84C2CE.4080905@gmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.V3H.2FueMB@chimera>
	<20100906075007.5797f524@schatten.dmk.lab>
	<4C84C2CE.4080905@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010 06:30:38 -0400
Doug Nazar <nazard.lkml@gmail.com> wrote:

>   On 2010-09-06 1:50 AM, Florian Mickler wrote:
> >
> > Paul provided a patch at
> > https://bugzilla.kernel.org/attachment.cgi?id=28832 .
> >
> > Has he pinged you already about it? You are not subscribed to the bug
> > and I didn't see anything on the netdev mailinglist or lkml.
> >
> 
> Sorry, kinda ignored this one once David said it was being worked on. 
> I've been busy trying to track down why my wireless isn't working.
> 
> For the record, neither Paul's patch (095d05: softirq: adjust error 
> check) or Ben's (24cd80: 
> 3c59x: Remove incorrect locking; correct documented lock hierarchy) 
> which is sitting in the net-2.6 fix the issue. Tested atop 2bfc96a 
> (Linux 2.6.36-rc3)
> 
> It seems to be an init issue as it only happens once during boot and 
> doesn't impact functionality.
> 
> Doug
> 

Thanks for the update. 

Cheers,
Flo
