Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0GIWbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:31:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37871 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0GIWbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:31:38 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278713600.7122.22.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
	 <1278713600.7122.22.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 15:31:20 -0700
Message-ID: <1278714680.2349.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:13 -0700, Fernando Lopez-Lezcano wrote:
> On Fri, 2010-07-09 at 12:54 -0700, john stultz wrote:
> > On Fri, 2010-07-09 at 12:02 -0700, Fernando Lopez-Lezcano wrote:
> > > Ok, I got one! (had to go buy a null modem cable, I thought I had one
> > > but it has disappeared since the last time I did this :-)
> > 
> > Great! Sorry to make you go shopping! But this points out the problem
> > nicely.
> 
> No problem at all, I was sure I had one... anyway, I still need it :-<
> 
> > > Find it below... it keeps spewing stuff every once in a while. Hopefully
> > > this will be enough. No response from the network or the keyboard or
> > > mouse at this point, reset is the only way out. 
> > > 
> > > I can retest if somebody comes up with a patch...
> 
> Sorry, it looks like the patch patched correctly and this is the new
> kernel, but I still get a hang as before. 

Huh. Exact same backtrace? Maybe there's more then one issue with that
function...

thanks for the testing!
-john


