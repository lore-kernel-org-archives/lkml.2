Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966043Ab2EORYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:24:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42401 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966024Ab2EORYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl>
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
 <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
 <4FB0197F.6010000@linux.vnet.ibm.com> <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl>
 <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 10:24:16 -0700
X-Google-Sender-Auth: PfUVvNrjMIEzqLOeWoR1uGRxdCE
Message-ID: <CA+55aFy1TGH07Ng-nbmWs2N8=kfFMCMosF1TsevLcHhCpWL-LQ@mail.gmail.com>
Subject: Re: Linux 3.4-rc7
To: John David Anglin <dave.anglin@bell.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikulas Patocka <mpatocka@redhat.com>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 5:42 PM, John David Anglin <dave.anglin@bell.net> wrote:
>
> I successfully booted 3.4-rc7 with this change on rp3440 (4 cpu smp).  My
> build also
> included cache and other fixes that are being discussed on the parisc list.

Can somebody send the final patches with proper subject lines etc,
instead of hiding them in unrelated threads? I hate picking up patches
that I don't personally know from the middle of some random thread.

                      Linus
