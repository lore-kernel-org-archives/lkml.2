Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0FNOgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:36:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:33257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0FNOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:36:37 -0400
Date: Mon, 14 Jun 2010 07:38:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Message-ID: <20100614073853.6fa2f91f@infradead.org>
In-Reply-To: <20100614140941.GA3581@swordfish.minsk.epam.com>
References: <20100613203352.GA3577@swordfish>
	<1276461183.2659.4.camel@maxim-laptop>
	<201006140136.18652.rjw@sisk.pl>
	<20100614140941.GA3581@swordfish.minsk.epam.com>
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

On Mon, 14 Jun 2010 17:09:41 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Hello,
> Not sure if this simple solution is the correct one.

it's not; the caller needs to pass in the cpu number I suspect for this
to be really correct....

I just returned from family emergency travel and will take a look today


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
