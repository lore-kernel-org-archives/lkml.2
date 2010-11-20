Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0KTUZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 15:25:12 -0500
Received: from solo.fdn.fr ([80.67.169.19]:36928 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0KTUZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 15:25:11 -0500
Date: Sat, 20 Nov 2010 21:25:07 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101120202507.GX7194@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jesper Juhl <jj@chaosbits.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
References: <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins> <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net> <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com> <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost> <AANLkTikeLeLvYcZJ4HcAUH1ax13scgnrT27CSR=YzO_C@mail.gmail.com> <alpine.LNX.2.00.1011202031130.24071@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1011202031130.24071@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl, le Sat 20 Nov 2010 20:33:21 +0100, a écrit :
> Or how about (just brainstorming here) a group per 'process group'?

That'd be too heavy by Linus' measurement, as you have a process group
for each shell command.

Samuel
