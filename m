Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2KZHJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:09:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab2KZHJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:09:38 -0500
Date: Mon, 26 Nov 2012 12:39:33 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5jL8zCt5ghW4ODPL9+SyC9+mbuw=4JMUngepY5fC8pSikQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211261237490.6682@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz> <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz>
 <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz> <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com> <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz>
 <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com> <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz> <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com> <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz>
 <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com> <alpine.LFD.2.02.1211221934220.19768@wniryva.cad.erqung.pbz> <CAGXu5jL8zCt5ghW4ODPL9+SyC9+mbuw=4JMUngepY5fC8pSikQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Sat, 24 Nov 2012, Kees Cook wrote --+
| Well, "ever" meaning "if depth is hit, always fail out", yes. This is 
| intentional. We do not want to attempt module loading if we hit a recursion 
| limit.

  Ah yes, that's right!

Thanks so much! :)
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
