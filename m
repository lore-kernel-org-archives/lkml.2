Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2CZWyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:54:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2CZWyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:54:01 -0400
Date: Mon, 26 Mar 2012 15:53:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net, pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-Id: <20120326155359.e5092006.akpm@linux-foundation.org>
In-Reply-To: <CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
	<20120326142908.c5248aec.akpm@linux-foundation.org>
	<CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 16:45:10 -0600
Daniel Drake <dsd@laptop.org> wrote:

> On Mon, Mar 26, 2012 at 3:29 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > s/fix/break/? __"Originally-from" is not a recognised tag. __If this code
> > is based upon an earlier version from Paul then Signed-off-by: is
> > correct.
> >
> > What's going on here? __What are you trying to communicate?
> 
> I'm trying to take Ingo's suggestion, in the thread "[patch 1/8] x86,
> olpc: add debugfs interface for EC commands" he wrote:
> 
> ====
> This is not a valid signoff sequence - the 'From: ' author of
> the patch must be the first SOB line.
> 
> The way to do this is either to have a:
> 
>  From: Paul Fox <pgf@laptop.org>
> 
> or to covert Paul Fox's SOB to a credit line, such as:
> 
>  Originally-from: Paul Fox <pgf@laptop.org>
> ====
> 
> The original code was from Paul Fox. I changed it somewhat
> significantly, and Paul approves of the end result.
> Can someone suggest a way of expressing this, including tag ordering,
> that will be accepted by all parties?  :)

From: Daniel Drake <dsd@laptop.org>

....

The original code was from Paul Fox.  I changed it somewhat
significantly, and Paul approves of the end result.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>


If I see a changelog like that, I will assume that Paul is OK with you
having the primary authorship (although some suspicion remains ;)). 
Especially when both individuals are from the same organization.

You could swap the order of the Signed-off-by: lines, but the ordering
of those lines isn't at all a reliable indication of anything.  So
nobody should actually *use* the ordering for any purpose.  It is best
to explicitly clarify these things in the changelog text.

