Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab0E0SQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934534Ab0E0SQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:16:00 -0400
Date: Thu, 27 May 2010 20:13:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 1/3] sys_personality: validate personality before
	set_personality()
Message-ID: <20100527181351.GA21758@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Linus Torvalds wrote:
>
>
> On Thu, 27 May 2010, Oleg Nesterov wrote:
> >
> > You can also remove this "return -EINVAL", this is no longer possible.
>
> I've already removed the patch from my tree, I wasn't going to commit it
> without somebody testing it. So maybe you could re-do the series with that
> cleanup too?

Sure, will do tomorrow.

Oleg.

