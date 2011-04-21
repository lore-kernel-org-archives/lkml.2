Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1DUUQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1DUUQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:16:18 -0400
Date: Thu, 21 Apr 2011 16:15:34 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, David Daney <ddaney@caviumnetworks.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421201534.GA19128@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joe Perches <joe@perches.com>,
	David Daney <ddaney@caviumnetworks.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	BorislavPetkov <bp@alien8.de>
References: <20110421192117.GA14249@redhat.com>
 <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
 <4DB087EC.1010205@caviumnetworks.com>
 <1303415086.24766.84.camel@Joe-Laptop>
 <20110421195801.GA15126@redhat.com>
 <BANLkTinWV_OriM0mdoVdKWZNHhEUUmWDog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinWV_OriM0mdoVdKWZNHhEUUmWDog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 01:09:11PM -0700, Linus Torvalds wrote:
 > On Thu, Apr 21, 2011 at 12:58 PM, Dave Jones <davej@redhat.com> wrote:
 > > @@ -359,7 +359,8 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 > >                   -fno-strict-aliasing -fno-common \
 > >                   -Werror-implicit-function-declaration \
 > >                   -Wno-format-security \
 > > -                  -fno-delete-null-pointer-checks
 > > +                  -fno-delete-null-pointer-checks \
 > > +                  -Wno-unused-but-set-variable
 > 
 > Does this work ok for older gcc's? Do they understand that
 > -Wno-unused-by-set-variable?
 > 
 > gcc-4.5.1 seems to understand it, but what about much older gccs?

aparently not. I'll poke at it some more.

	Dave


