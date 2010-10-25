Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab0JYNLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:11:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0JYNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:11:29 -0400
Date: Mon, 25 Oct 2010 15:11:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025131127.GC17622@basil.fritz.box>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025091913.GA17622@basil.fritz.box>
 <20101025111530.GA27659@elte.hu>
 <20101025123753.GB17622@basil.fritz.box>
 <20101025125531.GA6075@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025125531.GA6075@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 02:55:31PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Mon, Oct 25, 2010 at 01:15:30PM +0200, Ingo Molnar wrote:
> > 
> > > > > > einj.c: it's about the 3rd separate 'error injection' concept that got 
> > > > > > introduced ...
> > > > > 
> > > > > EINJ is a true platform feature, not just software feature. We need to support 
> > > > > it to debug various hardware error features.
> > > > 
> > > > Also having multiple error injecting interfaces is a good thing.
> > > 
> > > It's never a good thing to have separate, vendor dependent interfaces for what 
> > > to the user is basically the same conceptual thing!
> > 
> > Perhaps a simple example (simplified, in practice there are more complications) 
> > makes it more clear:
> > 
> > The memory error handler does different actions depending on what the state the 
> > page the error is happening on is in.
> 
> What you appear to be arguing for is the ability to inject different types of 
> events.

Different events in different contexts with different drivers 
with different parameters using different tools.

Commonality: about 0% exept there's "error" somewhere in the description.

-Andi
