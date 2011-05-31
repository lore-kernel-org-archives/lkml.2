Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab1EaTvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:51:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58321 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab1EaTvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:51:10 -0400
Date: Tue, 31 May 2011 21:50:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110531195051.GB26970@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
 <20110531165252.GB8971@srcf.ucam.org>
 <4DE5360D.5070809@zytor.com>
 <20110531185122.GA11998@srcf.ucam.org>
 <1306868609.6317.25.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306868609.6317.25.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> [...] the possibility of local attackers performing cache timing 
> attacks to find the kernel image location at runtime, [...]

How would these work, roughly?

Thanks,

	Ingo
