Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2CZXFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:05:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CZXFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:05:42 -0400
Date: Mon, 26 Mar 2012 16:05:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net,
        pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-Id: <20120326160540.ca746457.akpm@linux-foundation.org>
In-Reply-To: <4F70F1EC.3070004@zytor.com>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
	<20120326142908.c5248aec.akpm@linux-foundation.org>
	<CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
	<4F70F1EC.3070004@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 15:47:08 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/26/2012 03:45 PM, Daniel Drake wrote:
> > On Mon, Mar 26, 2012 at 3:29 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >> s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
> >> is based upon an earlier version from Paul then Signed-off-by: is
> >> correct.
> >>
> >> What's going on here?  What are you trying to communicate?
> > 
> > I'm trying to take Ingo's suggestion, in the thread "[patch 1/8] x86,
> > olpc: add debugfs interface for EC commands" he wrote:
> > 
> > ====
> > This is not a valid signoff sequence - the 'From: ' author of
> > the patch must be the first SOB line.
> > 
> > The way to do this is either to have a:
> > 
> >  From: Paul Fox <pgf@laptop.org>
> > 
> > or to covert Paul Fox's SOB to a credit line, such as:
> > 
> >  Originally-from: Paul Fox <pgf@laptop.org>
> > ====
> > 
> > The original code was from Paul Fox. I changed it somewhat
> > significantly, and Paul approves of the end result.
> > Can someone suggest a way of expressing this, including tag ordering,
> > that will be accepted by all parties?  :)
> > 
> 
> My recommendation is:
> 
> Originally-by: Paul Fox <pgf@laptop.org>
> 
> ... followed by Signed-off-by: in the order of patch flow.  Approving a
> patch, when not passing through, is indicated by Acked-by: or Reviewed-by:

I'd be OK with that, but first we should define what "Originally-by:"
means!  I'd want it to mean that a) Paul was the original author and b)
Paul approves the recording of Daniel as the primary author.
