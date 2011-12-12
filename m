Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1LLSbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:31:43 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58926 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1LLSbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:31:41 -0500
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
In-Reply-To: <4EE645B0.9090501@redhat.com>
References: <20111210132220.083204833@linutronix.de>
	 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	 <alpine.LFD.2.02.1112102144370.3020@ionos>
	 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	 <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos>
	 <20111211155347.GA1297@elte.hu>
	 <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
	 <4EE645B0.9090501@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 12 Dec 2011 20:31:38 +0200
Message-ID: <1323714698.1428.299.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 20:19 +0200, Avi Kivity wrote:
> On 12/12/2011 01:19 PM, Pekka Enberg wrote:
> > On Sun, Dec 11, 2011 at 5:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > > Okay, but look at it from another angle: the top output i
> > > generate is about 300k characters. 5000 msecs to execute it
> > > means 16 usecs overhead per character - or about 50k cycles - on
> > > a top of the class x86 CPU.
> >
> > I'm seeing 1.5 usecs per character for this little benchmark:
> 
> No interrupts, right?  Things look differently with one interrupt per
> character and none. 

No interrupts. I was simply trying to measure PIO overhead to see how
bad the 15 usec per character Ingo measured really is.

			Pekka

