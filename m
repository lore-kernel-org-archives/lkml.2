Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1JJHAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:00:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50396 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1JJHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:00:32 -0400
Date: Mon, 10 Oct 2011 09:00:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, pavel@ucw.cz, rjw@sisk.pl,
        linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <baohua.song@csr.com>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_delay kernel param as well
 as resume_delay
Message-ID: <20111010070028.GA11577@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Barry Song <21cnbao@gmail.com>, Barry Song <Barry.Song@csr.com>,
	pavel@ucw.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
	linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
	Barry Song <baohua.song@csr.com>
References: <1318225452-10397-1-git-send-email-Barry.Song@csr.com>
 <20111010062653.GB4139@liondog.tnic>
 <CAGsJ_4zSUYPrK3Bdo4p5bL25PO7orAJJByRAx2U=OT-JE62uHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zSUYPrK3Bdo4p5bL25PO7orAJJByRAx2U=OT-JE62uHw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 02:34:45PM +0800, Barry Song wrote:
> >> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> >> index b3da53c..f73a00e 100644
> >> --- a/kernel/power/hibernate.c
> >> +++ b/kernel/power/hibernate.c
> >> @@ -33,6 +33,7 @@
> >>  static int nocompress = 0;
> >>  static int noresume = 0;
> >>  static int resume_wait = 0;
> >> +static int resume_delay = 0;
> >
> > These static variables get zeroed needlessly and checkpatch actually
> > warns about that. Maybe fix that up while you're there?
> 
> yes. right. i initilized it to 0 to keep consistent coding style with
> the context because there were other variants doing that.
> i'd like to delete all initialization together as a seperate patch. Or
> do you want to do that?

Nah, you go ahead :-).

Thanks.

-- 
Regards/Gruss,
    Boris.
