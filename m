Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2HQNeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:34:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2HQNd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:33:57 -0400
Date: Fri, 17 Aug 2012 15:33:48 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com, nyoushchenko@mvista.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro
Subject: Re: UBI fastmap updates
Message-ID: <20120817153348.7a0a50a0@spider.haslach.nod.at>
In-Reply-To: <1345209115.27859.84.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1345209115.27859.84.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 17 Aug 2012 16:11:55 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
> We do not do anything like this in UBI because UBI does not need this,
> it does not have any complex data structures on the media.
> 
> With fastmap - I am unsure. I think it is not a problem, because
> probably you never append more data, you just re-write everything,
> right?

Yep, the on-flash fastmap is immutable.

Thanks,
//richard
