Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab1EZUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:02:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43956 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755990Ab1EZUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:02:17 -0400
Date: Thu, 26 May 2011 22:02:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
Message-ID: <20110526200207.GB15959@elf.ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20110518172552.6d482c7a.akpm@linux-foundation.org>
 <20110526060842.GA13933@localhost.ucw.cz>
 <4DDE80FE.7010005@schaufler-ca.com>
 <1306433514.24986.26.camel@localhost.localdomain>
 <20110526183849.GA4563@ucw.cz>
 <4DDEAA3F.3030008@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDEAA3F.3030008@schaufler-ca.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2011-05-26 12:30:07, Casey Schaufler wrote:
> On 5/26/2011 11:38 AM, Pavel Machek wrote:
> > On Thu 2011-05-26 14:11:54, David Safford wrote:
> >> On Thu, 2011-05-26 at 09:34 -0700, Casey Schaufler wrote:
> >>> On 5/25/2011 11:08 PM, Pavel Machek wrote:
> >>>> ...
> >>>> Fourthly, is it likely to find its way to the next cellphone I buy,
> >>>> and will it prevent me from rooting it?
> >>> That will of course depend on the phone vendor. You are certainly
> >>> going to be able to vote with your checkbook (digital wallet?) but
> >>> odds are pretty good that should EVM prove effective it will be
> >>> ubiquitous within the next five years on embedded devices.
> > Hmm. But maybe it is more effective to vote with NAKs, now? It does
> > not seem to have any non-evil uses.
> >
> > Phone vendors will play nasty tricks on us, but... why make it easy
> > for them?
> 
> For one thing, it is probable that in the not-too-distant future
> the phone will not be yours. Many service providers are moving in
> the direction of zero-cost phones. The subscriber will pay the

Really? References?

No, I don't think this is going to happen, for variety of reasons. 1)
prepaid cards, 2) phones are easily damaged, 3) phones are often stolen.

> Most people will not notice the difference. Consider this a
> nasty trick if you want to. I expect that the average consumer

I _do_ consider it nasty trick...

> Welcome to computers in the 21st century.

...and I do not want to help people playing nasty tricks. Protection
against offline attacks should not be merged.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
