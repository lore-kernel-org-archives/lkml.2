Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0KTWPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 17:15:06 -0500
Received: from solo.fdn.fr ([80.67.169.19]:34799 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0KTWPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 17:15:05 -0500
Date: Sat, 20 Nov 2010 23:15:01 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Konstantin Svist <fry.kun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Valdis.Kletnieks@vt.edu, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101120221501.GQ7194@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Konstantin Svist <fry.kun@gmail.com>,
	Mike Galbraith <efault@gmx.de>, Jesper Juhl <jj@chaosbits.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Valdis.Kletnieks@vt.edu, Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
References: <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net> <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com> <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost> <AANLkTikeLeLvYcZJ4HcAUH1ax13scgnrT27CSR=YzO_C@mail.gmail.com> <alpine.LNX.2.00.1011202031130.24071@swampdragon.chaosbits.net> <1290282678.28711.23.camel@maggy.simson.net> <4CE84578.5030800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE84578.5030800@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Svist, le Sat 20 Nov 2010 14:02:32 -0800, a écrit :
> Will that have an effect on software like Chromium which creates a fork 
> for each tab? If a user opens Thunderbird and Chromium with 100 tabs, 
> Thunderbird should probably get 50% CPU time instead of just 1%...

Chromium doesn't create a session or even a process group for each tab.

Samuel
