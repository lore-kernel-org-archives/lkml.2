Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1CWC0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 22:26:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42688 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab1CWC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 22:26:45 -0400
Date: Tue, 22 Mar 2011 22:26:39 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <1300842219.2402.309.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Benjamin Herrenschmidt wrote:

> On Tue, 2011-03-22 at 22:37 +0000, Andy Green wrote:
> > > that a device-tree based approach is much better in the long run
> > (and
> > > more flexible) despite Andy odd quasi-religious aversion for it.
> > 
> > As Mark Brown wrote earlier about this, the Device Tree
> > "implementation 
> > just isn't there in mainline".
> 
> Right and will take even longer to get there as long as short sighted
> people like yourself appear to run some kind of religious battle against
> it for no good technical reason that I can fathom so far.

Sorry Ben, but you are the one who sounds like a priest here, having 
invoked the "religious" qualifier twice in a row in this thread.

I think that Andy is asking absurdly good questions which are backed by 
candid logic and reasoning.  If anything, his arguments are purely 
technical and extremely practical. And so far all he's got for answers 
was rather subjective, emotionally charged and even dogmatic.

With regards to DT on ARM I'm rather "softly" convinced this is a good 
thing.  However seeing a persisting lack of truly technical answers to 
Andy's questions is rather disturbing, and makes me wish for much more 
than the current hype around DT which appears to fall flat when 
challenged.

There is one hard fact that no one can ignore: DT support on ARM still 
has a long way to go before it is truly usable.  The world just can't 
stop turning until this is ready.


Nicolas
