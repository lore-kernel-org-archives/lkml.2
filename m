Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0FODhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 23:37:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:56210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0FODhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 23:37:46 -0400
Date: Mon, 14 Jun 2010 20:40:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Message-ID: <20100614204021.52c50cdc@infradead.org>
In-Reply-To: <20100614151735.GB3448@swordfish.minsk.epam.com>
References: <20100613203352.GA3577@swordfish>
	<1276461183.2659.4.camel@maxim-laptop>
	<201006140136.18652.rjw@sisk.pl>
	<20100614140941.GA3581@swordfish.minsk.epam.com>
	<20100614073853.6fa2f91f@infradead.org>
	<20100614145439.GA3448@swordfish.minsk.epam.com>
	<20100614080154.7d6a71fc@infradead.org>
	<20100614151735.GB3448@swordfish.minsk.epam.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 18:17:35 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> On (06/14/10 08:01), Arjan van de Ven wrote:
> > > decided to patch nr_iowait_cpu instead.
> > 
> > the bug is that it needs to be
> > 
> > nr_iowait_cpu(int cpu)
> > 
> 
> Something similar to this?


yup that'll do it

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
