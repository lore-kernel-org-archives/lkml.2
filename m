Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0JZUNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:13:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0JZUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:13:11 -0400
Date: Tue, 26 Oct 2010 16:12:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@elte.hu,
        hpa@zytor.com, nick.lowe@gmail.com, Borislav Petkov <bp@alien8.de>,
        tglx@linutronix.de
Subject: Re: Dynamic nop selection breaks boot on Geode LX
Message-ID: <20101026201227.GB10050@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com> <20101004154633.GA2900@redhat.com> <AANLkTikiQHLAM9GwMF8+spW-RgG9-=rducMLaThQmE+i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikiQHLAM9GwMF8+spW-RgG9-=rducMLaThQmE+i@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 09:08:27PM +0100, Daniel Drake wrote:
> Hi,
> 
> On 4 October 2010 16:46, Jason Baron <jbaron@redhat.com> wrote:
> > Hi Daniel,
> >
> > looks like I moved dynamic no-op selection way too early in the boot -
> > before the exception tables required to select invalid opcodes were
> > even set up. The patch belows moves them later and should resolve this
> > issue for you. thanks for narrowing it down!
> 
> Bump... This patch has not been merged. I see that there is still some
> lack of consensus in this area but please don't forget about it. The
> offending commit (f49aa448561fe) has ended up in Linus' tree, so
> Linus' tree does not boot on Geode as a result.
> 

yeah, sorry...I've been busy chasing down a compiler issue...I haven't
forgotten, and will post this shortly.

thanks,

-Jason

