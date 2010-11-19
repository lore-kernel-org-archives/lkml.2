Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab0KSBYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:24:10 -0500
Received: from solo.fdn.fr ([80.67.169.19]:34882 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757678Ab0KSBYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:24:08 -0500
Date: Fri, 19 Nov 2010 02:23:48 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119012348.GM6024@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Mike Galbraith <efault@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
	Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com> <20101119000204.GE6024@const.famille.thibault.fr> <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com> <20101119005942.GL6024@const.famille.thibault.fr> <1290129157.18039.70.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290129157.18039.70.camel@maggy.simson.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith, le Thu 18 Nov 2010 18:12:37 -0700, a écrit :
> I think that could be done with a fork flag with the same semantics as
> reset on fork.  Once your task launcher (ala kdeinit) is tagged, it
> launches task groups, the children lose that ability.

Mmm, even if always creating groups can have a slight overhead, you
should probably not prevent userspace from deciding to do so when it
knows it's appropriate.

Samuel
