Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2ANDlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 22:41:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52152 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2ANDln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 22:41:43 -0500
MIME-Version: 1.0
In-Reply-To: <4F10F3EF.8000908@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com> <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
 <4F10F117.40006@linux.vnet.ibm.com> <CA+55aFwWU8ieuV_EsA6nHwjV9iOgy04DEScngDKQ92wNGfPZ-Q@mail.gmail.com>
 <4F10F3EF.8000908@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 19:41:22 -0800
X-Google-Sender-Auth: zBCD6qrUPM9GgTh49dZj8dTLBSY
Message-ID: <CA+55aFwdfBQ+cx+YqrgjjBACr8uJ=FYcKqz6PWn1yZanqtcqZg@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 7:18 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
> By the way, in my excitement, while sending the patch I forgot to give
> credits to the problem reporters with a "Reported-by". Hope that gets
> resolved.

.. and in my excitement to get it fixed, I committed and pushed it out
without thinking about it either.

So no, reporters didn't get any glory this time.

Sucks to be them,

                 Linus
