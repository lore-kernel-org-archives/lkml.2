Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1EZTtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:49:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50538 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1EZTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:49:19 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Safford <safford@watson.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
In-Reply-To: <20110526183849.GA4563@ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110518172552.6d482c7a.akpm@linux-foundation.org>
	 <20110526060842.GA13933@localhost.ucw.cz>
	 <4DDE80FE.7010005@schaufler-ca.com>
	 <1306433514.24986.26.camel@localhost.localdomain>
	 <20110526183849.GA4563@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 15:49:07 -0400
Message-ID: <1306439347.3092.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 20:38 +0200, Pavel Machek wrote:
> On Thu 2011-05-26 14:11:54, David Safford wrote:
> > On Thu, 2011-05-26 at 09:34 -0700, Casey Schaufler wrote:
> > > On 5/25/2011 11:08 PM, Pavel Machek wrote:
> > > > ...
> > > > Fourthly, is it likely to find its way to the next cellphone I buy,
> > > > and will it prevent me from rooting it?
> > > 
> > > That will of course depend on the phone vendor. You are certainly
> > > going to be able to vote with your checkbook (digital wallet?) but
> > > odds are pretty good that should EVM prove effective it will be
> > > ubiquitous within the next five years on embedded devices.
> 
> Hmm. But maybe it is more effective to vote with NAKs, now? It does
> not seem to have any non-evil uses.
> 
> Phone vendors will play nasty tricks on us, but... why make it easy
> for them?
> 
> > um, not quite the right threat model...
> > 
> > Rooting is normally done through an exploit of the loader
> > or the kernel, neither of which EVM can prevent. The phones
> 
> Androids are often rooted by exploiting kernel or userspace
> security holes. G1 was rooted by shell that was left running on
> console...
> 
> > Whether or not the phone is rooted, IMA-Appraisal, EVM, and 
> > the Digital Signature Extensions help protect against remote
> > software attacks, and offline hardware attacks on individual
> > files, but not against rooting itself.
> 
> As far as I can tell, file signatures only prevent "offline hardware
> attacks"; that is  user trying to "attack" (== root) his own computer.
> 
> 								Pavel

Since when is my being able to detect and prevent unauthorized/malicious
files on my own system (eg. device - VM) from being read/executed deemed
evil?!  Are you suggesting that we're better off not knowing the
integrity or authenticity of a file?  I suggest you read Dave's
Integrity Overview whitepaper?

Becoming involved in designing when/how new EVM encrypted key(s) are
made available, determining if we need separate keyrings for EVM keys
and the keys for appraising files(IMA-appraisal signatures), or defining
the authorization mechanism required to add such keys (eg. LSM, extend
capabilities), would be welcomed.  Such discussions can take place on
either the LSM or linux-ima mailing lists.

thanks,

Mimi

