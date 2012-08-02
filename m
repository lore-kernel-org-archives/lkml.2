Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2HBPUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 11:20:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab2HBPUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:20:04 -0400
Date: Thu, 2 Aug 2012 17:19:59 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120802171959.76b3e192@spider.haslach.nod.at>
In-Reply-To: <1343920728.25013.131.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343919530.25013.116.camel@sauron.fi.intel.com>
	<20120802165921.17d83b8c@spider.haslach.nod.at>
	<1343920728.25013.131.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 02 Aug 2012 18:18:48 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
> > Hmm, and without fastmap it works fine?
> 
> Yes.
> 
> > I don't see much fastmap related here.
> 
> It is related to your changes in attach.c.

Okay, I'll dig into the issue.

Thanks,
//richard
