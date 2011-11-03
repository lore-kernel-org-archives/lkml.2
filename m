Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab1KCNGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:06:35 -0400
Received: from smtprelay0196.b.hostedemail.com ([64.98.42.196]:41888 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933143Ab1KCNGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:06:34 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2373
Date: Thu, 3 Nov 2011 13:06:33 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: hmh@hmh.eng.br
Cc: linux-kernel@vger.kernel.org
Message-ID: <379401738.337658.1320325593346.JavaMail.mail@webmail11>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111103081835.GA9330@elte.hu>
 <1758553229.334475.1320313445172.JavaMail.mail@webmail11>
 <20111103124243.GA17252@khazad-dum.debian.net>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.163.207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 3, 2011, Henrique de Moraes Holschuh wrote: 
 
> > On Thu, 03 Nov 2011, Artem S. Tashkinov wrote:
> > So, now the question is whether VCPUs quite an illogical enumeration is good for
> > power users as I highly doubt that 0-4, 1-5, 2-6 and 3-7 order can be easily
> > remembered and grasped. Besides neither top, not htop are HT aware so just by
> 
> Power users are directed to hwloc.  There's a reason I pointed you to it.
> hwloc would have told you upfront your real memory/cache/core/thread
> topology, either in text mode, through graphics, or as XML:
> 
> Here's hwloc's "lstopo" text output for my single-processor X5550:
> 
> Machine (6029MB) + Socket #0 + L3 #0 (8192KB)
>   L2 #0 (256KB) + L1 #0 (32KB) + Core #0
>     PU #0 (phys=0)
>     PU #1 (phys=4)
>   L2 #1 (256KB) + L1 #1 (32KB) + Core #1
>     PU #2 (phys=1)
>     PU #3 (phys=5)
>   L2 #2 (256KB) + L1 #2 (32KB) + Core #2
>     PU #4 (phys=2)
>     PU #5 (phys=6)
>   L2 #3 (256KB) + L1 #3 (32KB) + Core #3
>     PU #6 (phys=3)
>     PU #7 (phys=7)

A very useful utility indeed, thank you! Still I wonder if for the sake of simplicity 
it is possible to show and present virtual CPU pairs to the user in natural order,
(0,1 2,3 4,5 6,7) not how it's currently done (0,4 1,5 2,6 3,7). I cannot believe
it's difficult to change the userspace representation of virtual CPU pairs.


