Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1AVIUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 03:20:04 -0500
Received: from freeflow.nu ([178.79.134.28]:58537 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1AVIUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 03:20:02 -0500
Subject: Re: [PATCH 0/7] Nexus One Support
From: Pekka Enberg <penberg@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Daniel Walker <dwalker@codeaurora.org>, Dima Zavin <dmitriyz@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
In-Reply-To: <20110121234930.GK3043@thunk.org>
References: <1295576730.4096.24.camel@Joe-Laptop>
	 <1295624801.19880.13.camel@m0nster>
	 <20110121094827.41818a55@jbarnes-desktop>
	 <20110121095658.1ab623fe@jbarnes-desktop>
	 <1295632828.19880.22.camel@m0nster>
	 <20110121100441.06a94482@jbarnes-desktop>
	 <1295633882.19880.31.camel@m0nster>
	 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	 <1295642995.19880.42.camel@m0nster>
	 <AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com>
	 <20110121234930.GK3043@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 22 Jan 2011 10:19:58 +0200
Message-ID: <1295684398.19231.47.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Fri, Jan 21, 2011 at 10:49 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> > > I'll add this list into the commit text ..

On Fri, Jan 21, 2011 at 11:05:54PM +0200, Pekka Enberg wrote: 
> > So why is everyone bitching at Daniel when he's doing something the
> > Android folks should have done themselves a long time ago?

On Fri, 2011-01-21 at 18:49 -0500, Ted Ts'o wrote:
> Two wrongs don't make a right.  And it's not like not submitting
> changes is wrong, although granted it's not ideal.  (I'd say removing
> attribution from a git commit is even worse.  If you're doing the
> equivalent of a cherry pick, you should preserve the Author field.
> Even if you're doing some cleanup work, as the maintainer I generally
> preserve the Author line, and will simply add the fact that I did some
> cleanup to the commit body.  The question is who did more work; the
> person who originally submitted the code, or the person who did the
> cleanup.)

Sure, it would have been nicer for everyone involved if Daniel would
have kept the original patches and added new patches to clean it up on
top of that to preserve the history. However, I don't understand the
harsh comments when this looks like a honest mistake! And I especially
don't understand the almost hostile attitude of the Android developers
who have been sitting on these patches for over a year now AFAICT.

			Pekka

