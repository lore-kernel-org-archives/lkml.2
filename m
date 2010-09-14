Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0INCPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0INCPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:15:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
X-Fcc: ~/Mail/linus
Cc: monstr@monstr.eu, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
In-Reply-To: Namhyung Kim's message of  Monday, 13 September 2010 19:07:13 +0900 <AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
	<1283442391-23612-15-git-send-email-namhyung@gmail.com>
	<4C8DCF72.4050701@monstr.eu>
	<AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com>
X-Windows: a terminal disease.
Message-Id: <20100914021532.9C53E403E6@magilla.sf.frob.com>
Date: Mon, 13 Sep 2010 19:15:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 13, 2010 at 16:14, Michal Simek <monstr@monstr.eu> wrote:
> > Hi,
> >
> > just for my info how does it look like this patch series?
> > I mean who should added that patches to mainline?
> >
> 
> Hello,
> 
> I am not sure but I hope Roland will take care of it.

Sorry, I didn't know you had any such expectation.  Oleg and I do not
autonomously maintain any ptrace tree that gets automatically merged or
anything like that.  Our Acked-by's are presumed to help your case and our
objections to hurt it, but you just have to submit patches to linus, akpm,
arch maintainers, or whatever other channels get merged regularly.  We're
not that kind of authoritative ourselves, though we are listed as the
ptrace maintainers.  We have to do the same with our own ptrace patches.


Thanks,
Roland
