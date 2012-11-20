Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2KTHIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:08:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab2KTHIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:08:16 -0500
Date: Tue, 20 Nov 2012 12:38:02 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, halfdog <me@halfdog.net>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CA+55aFx3LFH5Xj1OkNoy7vN5w8y5tH39MUDujKqF3BdnmYibLQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211201234500.5842@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
 <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz> <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
 <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com> <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz> <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com> <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
 <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com> <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz> <CA+55aFx3LFH5Xj1OkNoy7vN5w8y5tH39MUDujKqF3BdnmYibLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Mon, 19 Nov 2012, Linus Torvalds wrote --+
|   isn't your patch the one that does a request_module even without trying 
| without it? There was a discussion about why that isn't valid. Don't do it.

Yep, okay.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
