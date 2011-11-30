Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1K3TkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:40:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1K3TkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:40:21 -0500
Date: Wed, 30 Nov 2011 11:41:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org,
        tglx@linutronix.de, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-Id: <20111130114128.ad9c79be.akpm@linux-foundation.org>
In-Reply-To: <4ED60D59.6080308@canonical.com>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
	<20111025182450.GA9843@phenom.dumpdata.com>
	<20111027155329.0adc1358.akpm@linux-foundation.org>
	<20111028070838.GG12995@elte.hu>
	<20111028003935.a75d16b6.akpm@linux-foundation.org>
	<4ED60D59.6080308@canonical.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 12:02:49 +0100 Stefan Bader <stefan.bader@canonical.com> wrote:

> So, as of today, this seems to be back on the master branch of linux-next (I
> guess from Andrew putting it back, but I am never sure with linux-next). But I
> am not sure how/when this would go into Linus tree. I assume without any
> specific action maybe merge window for 3.3...
> We got some positive feedback on it from users running into the problem. So it
> seems like a valuable change. From the discusions so far I take that technically
> the change did not trigger resistance. For that reason I wanted to ask whether
> there is a chance that this looks important enough to be pushed before the next
> merge window...

I sent this patch to the x86 maintainers two weeks ago.  It was
ignored, as were the other 11 patches I sent.  Later I will resend them
all.  If they are again ignored I will later send them yet again, and
so on.


