Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab1EaU11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:27:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60300 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab1EaU10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:27:26 -0400
Date: Tue, 31 May 2011 22:27:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Matthew Garrett <mjg@redhat.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110531202712.GB28731@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
 <20110531165252.GB8971@srcf.ucam.org>
 <4DE5360D.5070809@zytor.com>
 <20110531185122.GA11998@srcf.ucam.org>
 <1306868609.6317.25.camel@dan>
 <20110531195551.GC26970@elte.hu>
 <4DE54C66.10106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE54C66.10106@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/31/2011 12:55 PM, Ingo Molnar wrote:
> > 
> > So ... could you *please* not shelf this idea just because people 
> > used lkml for what it was invented: argued with each other rather 
> > forcefully? :-)
> 
> The real issue is that if it can be (semi)trivially bypassed, then 
> there may not be much reason to do it.

Sure.

> Other than that, Ingo's idea at least have the merit that it would 
> break only older bootloaders doing things wrong.

I'm wondering, why would it break older bootloaders? It's just a 
slightly larger than usual kernel image, nothing is visible to the 
bootloader.

Thanks,

	Ingo
