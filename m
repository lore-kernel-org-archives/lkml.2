Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1DULgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:36:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1DULgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:36:16 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=Ar9dcRiOBTsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=_BtuxK9f_QJcpMfYURMA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Reiser <jreiser@bitwagon.com>
In-Reply-To: <20110421094606.174caaf6@lxorguk.ukuu.org.uk>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023737.290712238@goodmis.org>
	 <20110421094606.174caaf6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 07:36:12 -0400
Message-ID: <1303385773.7181.114.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 09:46 +0100, Alan Cox wrote:
> On Wed, 20 Apr 2011 22:28:26 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The Linux style for comparing is:
> > 
> >   var == 1
> >   var > 0
> 
> It's both and both forms are commonly used. I don't care what ftrace
> looks like but don't pedal bogus style. We have enough bogus style as it
> is.

I thought I read somewhere that this was the preferred method. But I
could be mistaking.

Anyway, the patch still stands, although I'll change the above line from
"Linux style" to "Linux ftrace style", as I'm the one that has to
maintain this code, and I prefer this method.

I translate: var == 1 as "var is one" so seeing "1 == var" my mind
translates that to "one is var" which just sounds funny. Every time I
see that notation I have to stop and think about it. I'm sure if I used
it enough that hesitation would vanish, but for now, I'll keep it as is.

I haven't done the "if (var = 1)" mistake since college.

-- Steve


