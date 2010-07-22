Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab0GVD0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:26:30 -0400
Received: from xenotime.net ([72.52.115.56]:40466 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751822Ab0GVD0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:26:24 -0400
Date: Wed, 21 Jul 2010 20:26:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Paulo Marques <pmarques@grupopie.com>, trivial@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17]Documentation/blockdev/paride.txt update web
 address.
Message-Id: <20100721202619.0a4413df.rdunlap@xenotime.net>
In-Reply-To: <4C46F840.6010908@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
	<1279687926-29360-2-git-send-email-justinmattock@gmail.com>
	<4C46E289.6010009@grupopie.com>
	<4C46F840.6010908@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 06:38:08 -0700 Justin P. Mattock wrote:

> On 07/21/2010 05:05 AM, Paulo Marques wrote:
> > Justin P. Mattock wrote:
> >> The patch below removes a web address due to me being unable
> >> to locate this at all. If anybody knows the location let
> >> me know and I'll resend.
> >>
> >> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> >>
> >> ---
> >>   Documentation/blockdev/paride.txt |    5 -----
> >>   1 files changed, 0 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/Documentation/blockdev/paride.txt b/Documentation/blockdev/paride.txt
> >> index e431267..11c4e3f 100644
> >> --- a/Documentation/blockdev/paride.txt
> >> +++ b/Documentation/blockdev/paride.txt
> >> @@ -409,9 +409,4 @@ the list manager is a robot that will subscribe you using the reply
> >>   address in your mail headers.  REMOVE any anti-spam gimmicks you may
> >>   have in your mail headers, when sending mail to the list server.
> >>
> >> -You might also find some useful information on the linux-parport
> >> -web pages (although they are not always up to date) at
> >> -
> >> -	http://www.torque.net/parport/
> >> -
> >
> > I don't think removing an address like this is the best option. At least
> > having the "old" address allows me to go to www.archive.org and find out
> > a lot of useful information.
> >
> > Maybe just marking it as "(dead link)" and warning the respective
> > maintainer would be better?
> >
> 
> 
> the whole tourque.net thing is dead.. it's not just this one here..
> there must be at-least four or five of them throughout the Documentation.
> 
> is there a new updated location? or is www.archive.org already the new 
> updated address?

He means to look at an archive of torque.net by using the "wayback machine"
at archive.org.  See http://web.archive.org/web/*/http://torque.net/parport/
and look at the latest archive of torque.net/parport/ .

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
