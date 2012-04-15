Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2DOF3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 01:29:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51897 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750946Ab2DOF3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 01:29:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19fWEsPMLpfQPCJuCYzv3dSTbQ5Gbcr+Zu8bJe35/
	sp+62Mev58jtYO
Message-ID: <1334467743.7802.17.camel@marge.simpson.net>
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Sun, 15 Apr 2012 07:29:03 +0200
In-Reply-To: <20120414084616.GA28505@gmail.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
	 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
	 <20120414005921.GA22114@infradead.org> <20120414084616.GA28505@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 10:46 +0200, Ingo Molnar wrote:

> I suspect the default view should be the 'most intelligent' mode 
> of assembly output we can offer - with easy toggles for the rare 
> cases where someone would like to do something special, plus 
> .perfconfig overrides for those with weird workflows and those 
> with a taste different from ours.

Maybe you just said that, but it sounded like the opposite.  If 'most
intelligent' means maximum circles and arrows for dummies, I agree ;-)

-Mike

