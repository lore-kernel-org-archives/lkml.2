Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab2EPR6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:58:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49586 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab2EPR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:58:39 -0400
X-Sasl-enc: RF583eF8ptWmmGyM+5HF/d2s9riqdhLqJlaokd4kgy1T 1337191117
Date: Wed, 16 May 2012 10:58:36 -0700
From: Greg KH <greg@kroah.com>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Joe Perches <joe@perches.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
Message-ID: <20120516175836.GB3094@kroah.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <1337184643.4818.8.camel@joe2Laptop>
 <CAFU-uVv3Nx7hK73RvXtRUD43EoCyY_ER+oe5RScPc32VuuDpPA@mail.gmail.com>
 <CA+5PVA56PO6v6pdCb5sd83XeC9a17oKNAb1MCru3vb39us2t0A@mail.gmail.com>
 <CAFU-uVueBEOzC065jynvLqFU3S76yVqFB20B0q75sbRVSFsSgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFU-uVueBEOzC065jynvLqFU3S76yVqFB20B0q75sbRVSFsSgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 07:01:54PM +0200, Philipp Riemer wrote:
> I thought about the fact that over time people move companies. In my
> case, I try to do some kind of time series analysis and thus it might
> be interesting to see who was employed but now works as a freelancer
> etc. Here, the opinion of other people who analyze the kernel such as
> Wang Chen, Greg KH, or Jonathan Corbet might be interesting...

The mailmap file does not show this type of thing very well at all, and
I wouldn't recommend trying to keep it up to date this way.  I say this
as someone who tries to keep track of who is working for whom.  This
information changes over time, and as others have pointed out, some
people use multiple email addresses to categorize their submittions
(work vs. hobby) for legal and personal reasons.

Our database has been made public at times, so you should be using that
instead of trying to update the mailmap file.

So while it might be nice to update it, why do you want to do so?  We
have updated and cleaned-up log files publicly if you want to use those
for research (they are in my github archive).  Modifying things here
probably would not be a good idea.

sorry,

greg k-h
