Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2CZVvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:51:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab2CZVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:51:48 -0400
Date: Mon, 26 Mar 2012 14:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net,
        pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-Id: <20120326145146.23fde0db.akpm@linux-foundation.org>
In-Reply-To: <4F70E042.4020703@zytor.com>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
	<20120326142908.c5248aec.akpm@linux-foundation.org>
	<4F70E042.4020703@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 14:31:46 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/26/2012 02:29 PM, Andrew Morton wrote:
> >>
> >> v4: really fix sign-off tags
> > 
> > s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
> > is based upon an earlier version from Paul then Signed-off-by: is
> > correct.
> > 
> > What's going on here?  What are you trying to communicate?
> 
> I have been using "Originally-by:" (not Originally-from:) to indicate
> content originally written by someone else which has then been
> dramatically redone.  It seems to communicate, but probably should be
> written into a spec somewhere.
> 

Well, if a person had any contribution at all, we should seek their
Signed-off-by:.  Otherwise they could say "hey, you admitted using my
code but I did not authorise its use", or any other range of bad IANAL
things?

If we want to provide additional details on the authorship trail then
fine, that can be done in English in the changelog.  And it can be done
far more clearly than in an ad-hoc tag whose meaning is unclear.

It's pretty unusual to see a patch which was authored by person A to
have "From: B".  Usually this comes about because B made a mistake.  I
will always query the authorship on such patches.  Sometimes it is
deliberate, but there's no consistent pattern in the reasoning.  For
this reason it is always best to fully explain the authorship
alteration in the changelog text.


If we want to add more tag types then OK, we can discuss that, clearly
define them, raise a patch against Documentation/SubmittingPatches and
start to use them.  But let's not invent new ones without explaining to
anyone else what they mean.


Generally if I see anything other than "Signed-off-by:", "Cc:",
"Tested-by:" "Reported-by:", "Acked-by:" or "Reviewed-by:", I consider
them to be undefined and will zap 'em, sometimes transferring the
intent into the changelog body instead.
