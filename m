Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0GVDb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:31:26 -0400
Received: from xenotime.net ([72.52.115.56]:54592 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752231Ab0GVDbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:31:25 -0400
Date: Wed, 21 Jul 2010 20:31:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: trapdoor6@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel bisect: a query regarding commit identifiers
Message-Id: <20100721203115.6eb992a2.rdunlap@xenotime.net>
In-Reply-To: <AANLkTinnlq27qoTicG-_C26N6Sv8pP8taEkXWF5BUE1b@mail.gmail.com>
References: <AANLkTim9-79EImktArUO2td5nqUAtp-Uag3j4BDzj_-E@mail.gmail.com>
	<AANLkTinnlq27qoTicG-_C26N6Sv8pP8taEkXWF5BUE1b@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 12:45:53 +0100 trapDoor wrote:

> On Wed, Jul 21, 2010 at 12:29 PM, trapDoor <trapdoor6@gmail.com> wrote:
> > Hello All,
> > Just a quick question. I'm going to do kernel bisect and was wondering
> > if there are commit identifiers for the rc-GIT versions ? Or maybe I
> > won't need it and could just do it like this:
> > git-bisect bad 2.6.35-rc2-git3
> > git-bisect good 2.6.35-rc2-git4
> >
> > ?
> 
> I meant the other way of course..
> git-bisect bad 2.6.35-rc2-git4
> git-bisect good 2.6.35-rc2-git3
> 
> >
> > Identifiers for rc versions appear in changelogs but I can't find
> > identifiers for the rc-git's. I think that doing bisect between rc-git
> > version within the same rc would save me some time. Assuming I will be
> > able to narrow a problem down to a particular rc initially ..

git snapshot IDs are stored at http://kernel.org/pub/linux/kernel/v2.6/snapshots/ ,
in the *.id files.  E.g.:

patch-2.6.35-rc5-git7.id contains:
cd5b8f8755a89a57fc8c408d284b8b613f090345

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
