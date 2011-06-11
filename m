Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab1FKC66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 22:58:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:52269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab1FKC65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 22:58:57 -0400
Date: Fri, 10 Jun 2011 20:02:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110610200233.5ddd5a31@infradead.org>
In-Reply-To: <20110610193713.GJ2230@linux.vnet.ibm.com>
References: <20110610151121.GA2230@linux.vnet.ibm.com>
	<20110610155954.GA25774@srcf.ucam.org>
	<20110610165529.GC2230@linux.vnet.ibm.com>
	<20110610170535.GC25774@srcf.ucam.org>
	<20110610171939.GE2230@linux.vnet.ibm.com>
	<20110610172307.GA27630@srcf.ucam.org>
	<20110610175248.GF2230@linux.vnet.ibm.com>
	<20110610180807.GB28500@srcf.ucam.org>
	<20110610184738.GG2230@linux.vnet.ibm.com>
	<20110610192329.GA30496@srcf.ucam.org>
	<20110610193713.GJ2230@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 12:37:13 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Jun 10, 2011 at 08:23:29PM +0100, Matthew Garrett wrote:
> > On Fri, Jun 10, 2011 at 11:47:38AM -0700, Paul E. McKenney wrote:
> > 
> > > And if I understand you correctly, then the patches that Ankita
> > > posted should help your self-refresh case, along with the
> > > originally intended the power-down case and special-purpose use
> > > of memory case.
> > 
> > Yeah, I'd hope so once we actually have capable hardware.
> 
> Cool!!!
> 
> So Ankita's patchset might be useful to you at some point, then.
> 
> Does it look like a reasonable implementation?

as someone who is working on hardware that is PASR capable right now,
I have to admit that our plan was to just hook into the buddy allocator,
and use PASR on the top level of buddy (eg PASR off blocks that are
free there, and PASR them back on once an allocation required the block
to be broken up)..... that looked the very most simple to me.

Maybe something much more elaborate is needed, but I didn't see why so
far.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
