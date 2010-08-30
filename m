Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0H3Nqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:46:49 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47201 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab0H3Nqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:46:48 -0400
Date: Mon, 30 Aug 2010 15:46:46 +0200
From: Florian Mickler <florian@mickler.org>
To: Meelis Roos <mroos@linux.ee>
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.kernel-testers
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
Message-ID: <20100830154646.05db5587@schatten.dmk.lab>
In-Reply-To: <alpine.SOC.1.00.1008301145230.29117@math.ut.ee>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.aU.BGueMB@chimera>
	<alpine.SOC.1.00.1008301145230.29117@math.ut.ee>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 11:45:56 +0300 (EEST)
Meelis Roos <mroos@linux.ee> wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2010-08-19 21:03 (11 days old)
> > Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> > References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> 
> Still present in 2.6.36-rc3.
> 

Thx for the update. 

I've updated the bugzilla entry accordingly.

Cheers,
Flo
