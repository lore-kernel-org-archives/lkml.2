Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab0KSA7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:59:46 -0500
Received: from solo.fdn.fr ([80.67.169.19]:58621 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab0KSA7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:59:45 -0500
Date: Fri, 19 Nov 2010 01:59:42 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119005942.GL6024@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
	linux-kernel@vger.kernel.org,
	Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com> <20101119000204.GE6024@const.famille.thibault.fr> <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds, le Thu 18 Nov 2010 16:42:27 -0800, a écrit :
> Once per session is about as much as is acceptable. That's the kind of
> granularity we should look at. So things like "groups per user",
> "groups per session", "groups per one graphical application" are good.
> Not things that can happen tens of thousands of times a second.

All right.  I believe that should already work quite well both for
desktop and servers indeed.  "Per one graphical application" will most
probably require desktop panel patching, however.

Samuel
