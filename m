Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1CUSZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:25:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36394 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751161Ab1CUSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:25:17 -0400
Date: Mon, 21 Mar 2011 13:24:21 -0500
From: Jack Steiner <steiner@sgi.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321182421.GB14562@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com> <4D878445.6090709@gmail.com> <20110321170832.GC12718@sgi.com> <4D8795A8.4060909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8795A8.4060909@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 09:15:04PM +0300, Cyrill Gorcunov wrote:
> On 03/21/2011 08:08 PM, Jack Steiner wrote:
> ...
> > 
> > We use KDB internally, and yes, it has the same issue. The version of the
> > patch that uses KDB OR's the "handled" status for both KDB & the UV NMI handler.
> > If either KDB or the UV NMI handler returns "handled", the code in traps.c exits
> > after the call to the first die notifier.
> > 
> > Not particularily pretty but I could not find a better way to do it.
> > 
> > --- jack
> 
>   Btw Jack, I somehow missed (sorry) this patch only handles UV NMI handler so
> for KGDB case you need some other patch on top?

Yes. Internally we usually apply the older KDB patches to our tree.


--- jack
