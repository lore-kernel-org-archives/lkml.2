Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0JQJMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:12:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49041 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab0JQJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H/bkGz9XKFTHX1pXNorVkBMIJ5yJYfUkT91f609MwatPhXmulMWKJCzQflHZsoaqO0
         BsjKtdwfS9f8ASORBGqVvxUG0lziYJO0Z6ZdoMszEHSdduaRvNsqwVuHZ+twwUkuFD1s
         NVpNwcH6ai910JVjF++Ph+IMz6bzALPK2LxlU=
Date: Sun, 17 Oct 2010 17:11:52 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Proper kernel irq time accounting -v4
Message-ID: <20101017091152.GB3468@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
 <1287155513.29097.1526.camel@twins>
 <1287156451.29097.1531.camel@twins>
 <AANLkTinL=FEo9wAaUQ8p6ton+eQxLk1m2BEj-3sof3H+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTinL=FEo9wAaUQ8p6ton+eQxLk1m2BEj-3sof3H+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:13:46AM -0700, Venkatesh Pallipadi wrote:
> On Fri, Oct 15, 2010 at 8:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-10-15 at 17:11 +0200, Peter Zijlstra wrote:
> >> OK, I'll take this, but will frob 4 to simply add PF_KSOFTIRQD.
> >>
> >> We can do all additional changes, possibly including what Eric
> >> suggested, at a later stage as increments.
> >>
> >> Thanks!
> >
> > *kablam!*
> >
> > booting with noirqtime doesn't work either, same explosion.
> 
> This crash seems to be from patch 8/8 that changed irq_enter. Please
> drop it for now and I will rework that.

Just notice this, so my reply to patch 8/8 will fix it.

Thanks,
Yong

> I will also send the cleanup changes including one that Eric suggested
> as incremental patches.
> 
> Thanks,
> Venki
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
