Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab2J0Krp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 06:47:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab2J0Krl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 06:47:41 -0400
Date: Sat, 27 Oct 2012 16:17:09 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <20121026183601.GR2616@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025041620.GH2616@ZenIV.linux.org.uk> <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com> <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz> <20121025120952.GI2616@ZenIV.linux.org.uk>
 <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Fri, 26 Oct 2012, Al Viro wrote --+
| > not. Module alias could dodge this though, I guess.
| "Could"?  Can you show a single module that would have name matching
| binfmt-[0-9a-f]*?  In other words, are they ever loaded _not_ via an
| alias?

  I understand. I was wondering if alias information is accessible in the 
kernel via any routine, alike find_module().

Just to get perspective about how many times request_module() would be called 
with the latest patch, in general installations(or distributions), how 
prevalent(in use) are binfmt-xxxx loadable modules?

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
