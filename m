Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1AUXtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:49:41 -0500
Received: from THUNK.ORG ([69.25.196.29]:58730 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab1AUXtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:49:39 -0500
Date: Fri, 21 Jan 2011 18:49:30 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, Dima Zavin <dmitriyz@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110121234930.GK3043@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@kernel.org>,
	Daniel Walker <dwalker@codeaurora.org>,
	Dima Zavin <dmitriyz@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Joe Perches <joe@perches.com>, linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	davidb@codeaurora.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 11:05:54PM +0200, Pekka Enberg wrote:
> 
> On Fri, Jan 21, 2011 at 10:49 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> > I'll add this list into the commit text ..
> 
> So why is everyone bitching at Daniel when he's doing something the
> Android folks should have done themselves a long time ago?

Two wrongs don't make a right.  And it's not like not submitting
changes is wrong, although granted it's not ideal.  (I'd say removing
attribution from a git commit is even worse.  If you're doing the
equivalent of a cherry pick, you should preserve the Author field.
Even if you're doing some cleanup work, as the maintainer I generally
preserve the Author line, and will simply add the fact that I did some
cleanup to the commit body.  The question is who did more work; the
person who originally submitted the code, or the person who did the
cleanup.)

					- Ted
