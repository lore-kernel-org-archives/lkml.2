Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1HLTGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:06:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34379 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754116Ab1HLTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:06:31 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/lbIBa2CDl8IDxyniZo960SS+sKaqif/jdVz7mQC
	E310JfqUkK1ug5
Date: Fri, 12 Aug 2011 21:06:26 +0200
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UserModeLinux-HOWTO.txt: remove ^H characters
Message-ID: <20110812190626.GK29043@debian.debian>
References: <1313108903-7351-1-git-send-email-j.neuschaefer@gmx.net>
 <20110812101928.f34da400.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110812101928.f34da400.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:19:28AM -0700, Randy Dunlap wrote:
> On Fri, 12 Aug 2011 02:28:23 +0200 Jonathan Neuschäfer wrote:
> 
> > If you can't read this patch, please run:
> > 
> > 	sed -i -e "s/[^\o10]\o10//g" \
> > 		Documentation/virtual/uml/UserModeLinux-HOWTO.txt
> > 
> > Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> > ---
> >  Documentation/virtual/uml/UserModeLinux-HOWTO.txt |  530 ++++++++++----------
> >  1 files changed, 265 insertions(+), 265 deletions(-)
> 
> I like the patch, although the text file seems to be quite old and it
> appears to be a generated file (from where?).

Yes, looks old. There has been only one (real) change in content since
2.6.12-rc2 (4ff4d8d3: um: add ucast ethernet transport).

Greetings,
	Jonathan Neuschäfer
