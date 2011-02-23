Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1BWIdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:33:22 -0500
Received: from ist.d-labs.de ([213.239.218.44]:60073 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab1BWIdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:33:21 -0500
Date: Wed, 23 Feb 2011 09:32:59 +0100
From: Florian Mickler <florian@mickler.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #22882] (2.6.37-rc1) amd64-agp module crashed on second
 load
Message-ID: <20110223093259.4c6e284d@schatten.dmk.lab>
In-Reply-To: <4D6424F4.4050208@oracle.com>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
	<f14qsMvj2tF.A.8BF.ffuYNB@chimera>
	<4D6424F4.4050208@oracle.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 13:04:52 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On 02/21/11 14:37, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.36 and 2.6.37.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22882
> > Subject		: (2.6.37-rc1) amd64-agp module crashed on second load
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2010-11-05 0:13 (109 days old)
> > Message-ID	: <20101104171333.fea1f498.randy.dunlap@oracle.com>
> > References	: http://marc.info/?l=linux-kernel&m=128891605213447&w=2
> > Handled-By	: Florian Mickler <florian@mickler.org>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=46682
> 
>   ^^^^^ this patch just needs to be merged into mainline.
> 
> thanks.  [resend due to multiple email failures (last attempt)]

I forgot about it[1]. I just now have bounced it forward to Andrew.
(Isn't David Airlie the Maintainer there?)

[1]https://patchwork.kernel.org/patch/539091/

Regards,
Flo
