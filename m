Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2IEFpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:45:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56564 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2IEFpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:45:10 -0400
Date: Wed, 5 Sep 2012 11:15:00 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, peterz@infradead.org,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>, oleg@redhat.com
Subject: Re: [PATCH v5 3/3] powerpc: Uprobes port to powerpc
Message-ID: <20120905054459.GB12521@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120824072602.GA32031@in.ibm.com> <20120824073132.GC32031@in.ibm.com> <1346822819.2257.49.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346822819.2257.49.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090505-7606-0000-0000-0000035B2940
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 03:26:59PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2012-08-24 at 13:01 +0530, Ananth N Mavinakayanahalli wrote:
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > This is the port of uprobes to powerpc. Usage is similar to x86.
> 
> Guys, can you do a minimum of build testing ?
> 
> This one breaks due to uprobe_get_swbp_addr() being defined in both
> asm and include/linux when CONFIG_UPROBE isn't set. You don't need
> to define it at all in fact, the generic code takes care of both the
> declaration for CONFIG_UPROBE and the empty inline for !CONFIG_UPROBE.
> 
> I'm fixing that one up myself but please, please, get yourself a test
> build script or something to make sure you don't at least break the
> build when the stuff you're adding isn't enabled (among others).

Sorry Ben. That was an oversight. Won't happen again.

Regards,
Ananth

