Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2HXSCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:02:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44884 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2HXSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:02:09 -0400
Date: Fri, 24 Aug 2012 20:02:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, David Ahern <dsahern@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCHv2 1/1] perf: Port to Android
Message-ID: <20120824180201.GA32144@gmail.com>
References: <1408973.PFKjjaXiS1@localhost.localdomain>
 <CAOJsxLFgvqJUwwnrtH8b9eOfNzUEZDmQGP1FVvToitD6ayYP0g@mail.gmail.com>
 <5036A182.7030707@gmail.com>
 <20120824040845.GA3001@srcf.ucam.org>
 <20120824133033.3d93cf5f@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824133033.3d93cf5f@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 24 Aug 2012 05:08:45 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Thu, Aug 23, 2012 at 03:32:50PM -0600, David Ahern wrote:
> > 
> > > Why not add support for the missing functions (on_exit, getsid,
> > > psignal and getline) to Bionic instead of perf?
> > 
> > Many vendors need to target existing Android platforms and 
> > don't have the luxury of waiting for code to get through 
> > Google review and then land on devices between 6 months in 
> > the future and never. The embedded world is dysfunctional in 
> > a whole bunch of ways.
> 
> So add a small library and link with -lstuffandroidforgot. 
> That's basically how the FSF dealt with all the proprietary 
> Unix library messes.
> 
> Come to think of it call the library "integrated build runtime 
> environment" and you can like with -libre ;)
> 
> It's also going to be far more maintainable and generically 
> useful for porting tools from GNU to 'droid userspace.

Well, you should see the uglies Git has to support Windows ;-)

Anyway, I'm not against making perf work on Android in 
principle, it is Obviously Useful (tm).

Thanks,

	Ingo
