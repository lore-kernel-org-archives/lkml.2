Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0IFFuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:50:12 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51693 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0IFFuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:50:10 -0400
Date: Mon, 6 Sep 2010 07:50:07 +0200
From: Florian Mickler <florian@mickler.org>
To: Doug Nazar <nazard.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com
Subject: Re: [Bug #17131] WARN with 3c905 boomerang NIC
Message-ID: <20100906075007.5797f524@schatten.dmk.lab>
In-Reply-To: <4AUWBNzTkbD.A.V3H.2FueMB@chimera>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.V3H.2FueMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 00:36:36 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17131
> Subject		: WARN with 3c905 boomerang NIC
> Submitter	: Doug Nazar <nazard.lkml@gmail.com>
> Date		: 2010-08-22 6:35 (8 days old)
> Message-ID	: <4C70C516.5020404@gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=128245894300623&w=2
> Handled-By	: David Miller <davem@davemloft.net>
> 
> 
Hi Doug!

Paul provided a patch at
https://bugzilla.kernel.org/attachment.cgi?id=28832 .

Has he pinged you already about it? You are not subscribed to the bug
and I didn't see anything on the netdev mailinglist or lkml. 

Cheers,
Flo
