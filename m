Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0JOHmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:42:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0JOHmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:42:42 -0400
Date: Fri, 15 Oct 2010 09:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/olpc] x86, olpc: Add XO-1 poweroff support
Message-ID: <20101015074234.GA12431@elte.hu>
References: <20101010094032.9AE669D401B@zog.reactivated.net>
 <tip-bf1ebf007911d70a89de9a4a1b36d403e8eb064b@git.kernel.org>
 <20101015064152.GA438@elte.hu>
 <AANLkTimBBSB7-9-p7jDBQrx6kUMnT2c0QDzVCEJX8C7u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimBBSB7-9-p7jDBQrx6kUMnT2c0QDzVCEJX8C7u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Drake <dsd@laptop.org> wrote:

> On 15 October 2010 07:41, Ingo Molnar <mingo@elte.hu> wrote:
> > FYI, this commit introduced a new build failure on =m and CONFIG_PCI
> > off:
> >
> > arch/x86/kernel/olpc-xo1.c:65: error: implicit declaration of function ‘pci_enable_device_io’
> > arch/x86/kernel/olpc-xo1.c:71: error: implicit declaration of function ‘pci_request_region’
> > arch/x86/kernel/olpc-xo1.c:80: error: implicit declaration of function ‘pci_release_region’
> 
> Sorry about that.
> Randy Dunlap already sent a patch titled "[PATCH -next] x86: olpc-xo1
> uses/depends on PCI"
> 
> Any chance you can just pull that one into the tree? Or shall I
> resubmit to x86 maintainers specifically?

No, that's ok - i've added your Acked-by to Randy's fix.

Thanks,

	Ingo
