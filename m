Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0FDJDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:03:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47312 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0FDJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mIIl+0TbpZeg/dCu5tcEhjnXWzNIfFFXRbVV4tkEYUTdeTMj7ByD5W9N52IwJO4Mo4
         og6UffwG9OMNesIbJXD2sI/9uenulnG9VBRNW0PvmFCKF+12n/qykBPcidEZ0M25/3SY
         8OEvMY81n2zqzA8L6CudUbGFIJbA3rzTP5E9E=
MIME-Version: 1.0
In-Reply-To: <20100604085513.GE15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
	<AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
	<20100604075722.GA15181@elte.hu>
	<AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com>
	<20100604085513.GE15181@elte.hu>
Date: Fri, 4 Jun 2010 12:03:11 +0300
X-Google-Sender-Auth: 1ifU4DmakXIdLFUgb8AKz9jxGlQ
Message-ID: <AANLkTikjfFrcLrG3FzLfPt78B7L1637HCMIfNKo8XeHm@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brian Swetland <swetland@google.com>, tytso@mit.edu,
       Neil Brown <neilb@suse.de>, "Arve Hj?nnev?g" <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 11:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
> In any case, this is not to suggest that the suspend-blocker bits are
> 'impossible' to merge. I just say that if you start with your most difficult
> feature you should not be surprised to be on the receiving end of a 1000+
> mails flamewar on lkml ;-)

Indeed. This 'all or nothing' approach hasn't worked well in the past
and I highly doubt it will work now. It's much easier to work with
people when you have a track record of getting things merged and
actually maintaining the code.

                        Pekka
