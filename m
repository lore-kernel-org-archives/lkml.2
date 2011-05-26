Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1EZSjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:39:08 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38245 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753523Ab1EZSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:39:04 -0400
Date: Thu, 26 May 2011 20:38:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Safford <safford@watson.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
Message-ID: <20110526183849.GA4563@ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20110518172552.6d482c7a.akpm@linux-foundation.org>
 <20110526060842.GA13933@localhost.ucw.cz>
 <4DDE80FE.7010005@schaufler-ca.com>
 <1306433514.24986.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306433514.24986.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2011-05-26 14:11:54, David Safford wrote:
> On Thu, 2011-05-26 at 09:34 -0700, Casey Schaufler wrote:
> > On 5/25/2011 11:08 PM, Pavel Machek wrote:
> > > ...
> > > Fourthly, is it likely to find its way to the next cellphone I buy,
> > > and will it prevent me from rooting it?
> > 
> > That will of course depend on the phone vendor. You are certainly
> > going to be able to vote with your checkbook (digital wallet?) but
> > odds are pretty good that should EVM prove effective it will be
> > ubiquitous within the next five years on embedded devices.

Hmm. But maybe it is more effective to vote with NAKs, now? It does
not seem to have any non-evil uses.

Phone vendors will play nasty tricks on us, but... why make it easy
for them?

> um, not quite the right threat model...
> 
> Rooting is normally done through an exploit of the loader
> or the kernel, neither of which EVM can prevent. The phones

Androids are often rooted by exploiting kernel or userspace
security holes. G1 was rooted by shell that was left running on
console...

> Whether or not the phone is rooted, IMA-Appraisal, EVM, and 
> the Digital Signature Extensions help protect against remote
> software attacks, and offline hardware attacks on individual
> files, but not against rooting itself.

As far as I can tell, file signatures only prevent "offline hardware
attacks"; that is  user trying to "attack" (== root) his own computer.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
