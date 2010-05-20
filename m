Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0ETLnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:43:46 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57021 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737Ab0ETLnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:43:45 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 07:43:45 EDT
X-Sasl-enc: Bk0InpfzbyHrsGgW7iBh8HykXCvG40LLrjoLw3WBMODZ 1274355352
Subject: Re: [PATCH 2/8] autofs: Pushdown the bkl from ioctl
From: Ian Kent <raven@themaw.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Autofs <autofs@linux.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4BF4445F.9040104@zytor.com>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
	 <1274289855-10001-3-git-send-regression-fweisbec@gmail.com>
	 <4BF4279C.2000805@zytor.com> <20100519180832.GA9752@nowhere>
	 <4BF42A5E.6060503@zytor.com> <20100519190307.GC9752@nowhere>
	 <4BF4445F.9040104@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 19:35:45 +0800
Message-ID: <1274355346.2264.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 13:04 -0700, H. Peter Anvin wrote:
> On 05/19/2010 12:03 PM, Frederic Weisbecker wrote:
> >>
> >> But it's not ... it is locked at that point.  It's not lock*ing*, but it
> >> is not *unlocked*, either.  Furthermore, it is directly contradicting
> >> the naming scheme of the ops structure.
> >>
> > 
> > Would you prefer me to resend a patch?
> > 
> 
> Yes, that would be my preference.
> 
> We really need to set a date to kill off autofs3 completely -- I don't
> care if we rename anything or not -- and add it to feature-removal.txt.

Yes, my bad.
I have to get onto that, sorry.

Ian

