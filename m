Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1HXVfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:35:52 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:35077 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752116Ab1HXVfv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:35:51 -0400
Subject: Re: [PATCH] UserModeLinux-HOWTO.txt: remove ^H characters
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jonathan =?ISO-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <20110812190626.GK29043@debian.debian>
References: <1313108903-7351-1-git-send-email-j.neuschaefer@gmx.net>
	 <20110812101928.f34da400.rdunlap@xenotime.net>
	 <20110812190626.GK29043@debian.debian>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 24 Aug 2011 18:35:43 -0300
Message-ID: <1314221743.3109.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 21:06 +0200, Jonathan Neuschäfer wrote:
> On Fri, Aug 12, 2011 at 10:19:28AM -0700, Randy Dunlap wrote:
> > On Fri, 12 Aug 2011 02:28:23 +0200 Jonathan Neuschäfer wrote:
> > 
> > > If you can't read this patch, please run:
> > > 
> > > 	sed -i -e "s/[^\o10]\o10//g" \
> > > 		Documentation/virtual/uml/UserModeLinux-HOWTO.txt
> > > 
> > > Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> > > ---
> > >  Documentation/virtual/uml/UserModeLinux-HOWTO.txt |  530 ++++++++++----------
> > >  1 files changed, 265 insertions(+), 265 deletions(-)
> > 
> > I like the patch, although the text file seems to be quite old and it
> > appears to be a generated file (from where?).
> 
> Yes, looks old. There has been only one (real) change in content since
> 2.6.12-rc2 (4ff4d8d3: um: add ucast ethernet transport).

Glad I noticed this patch in time, just today I was doing the same. FYI
I'm in the process of updating/splitting the document.

Thanks,
Davidlohr

> 
> Greetings,
> 	Jonathan Neuschäfer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


