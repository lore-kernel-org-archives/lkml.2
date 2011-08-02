Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1HBVps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:45:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20266 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1HBVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:45:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=moZSRRzfhIFQvZLt8HzYg43B/hNsBTaErOy/UjES9nfztyn3fcr4CDummO6PCMsGs
	BgUCu7sifkOQTtVG83Quw==
Date: Tue, 2 Aug 2011 14:45:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
In-Reply-To: <20110802111117.10a73b89@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1108021439030.12258@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <20110801183207.cea89a96.akpm@linux-foundation.org> <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com> <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
 <20110802101614.009cdf42@lxorguk.ukuu.org.uk> <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com> <20110802111117.10a73b89@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Alan Cox wrote:

> > That's obviously wrong since all of the applications that I've cited 
> > that have been fixed to date have been the result of users actually 
> > noticing the printk_once() and emailing me directly to pass it along to 
> > the appropriate parties.  I've also found other cases where bugzilla 
> > entries were created based on that single line warning by users, who in 
> > turn get distros and maintainers to convert to the new interface.
> 
> And what did the users do - they complained to the distribution.
> 

All of the examples that I've cited that were fixed as a result of the 
printk_once() were through bugzilla for the developers of those 
applications, I didn't talk to any distro when I publically said I would 
handle all reports of this warning that people didn't know how to triage.

> Actually this raises a more interesting question - would it make sense to
> have a moderated notification list for poking all the distributions about
> things like old API expiry >
> 

I think that's the goal of linux-api@vger.kernel.org although it only has 
113 subscribers, so it could probably play the role of a notification list 
as well as a place to report warnings for things such as deprecated 
interfaces.  More communication other than just sometimes stale entries in 
Documentation/ABI and Documentation/feature-removal-schedule.txt would 
certainly be helpful.
