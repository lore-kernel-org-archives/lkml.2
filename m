Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1EQJ3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:29:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab1EQJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:29:30 -0400
Date: Tue, 17 May 2011 11:29:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
Message-ID: <20110517092903.GJ22093@elte.hu>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <4DD19C81.8000902@zytor.com>
 <20110517070527.GD22305@elte.hu>
 <4DD23CB6.3050503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD23CB6.3050503@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> > Some programmable configurability seems necessary on the KVM side, as KVM 
> > has no control over how sane the guest kernel is.
> 
> We should simply expose the cpuid bit and cr4.smep.  If the guest kernel 
> feels it is up to it, it can enable smep itself.

Well, given that there's lots of legacy installations around it would be a neat 
KVM feature if it was possible to enable SMEP even if the guest kernel does not 
enable it. As an additional (optional) layer of security.

For example legacy Linux guests will work just fine, even if they do not enable 
SMEP themselves.

Thanks,

	Ingo
