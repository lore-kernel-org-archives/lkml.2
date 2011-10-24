Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1JXXMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 19:12:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab1JXXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 19:12:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=sFEoRPOp7Od4IGK5tTvpU8VaWyuKrPPv14ID3bhsuO20YCXbI42HFeR880+rNSW6/
	MiO8T2wheaOCzdcQ2SF+A==
Date: Mon, 24 Oct 2011 16:12:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sam Tygier <samtygier@yahoo.co.uk>, Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ike Panhc <ike.pan@canonical.com>
Subject: Re: 3.1rc10 null pointer dereference
 ideapad_backlight_notify_power
In-Reply-To: <1319493108.21408.YahooMailNeo@web25602.mail.ukl.yahoo.com>
Message-ID: <alpine.DEB.2.00.1110241611270.3296@chino.kir.corp.google.com>
References: <4E9EB1BC.9020709@yahoo.co.uk> <alpine.DEB.2.00.1110191315320.2892@chino.kir.corp.google.com> <4E9F7A25.1060001@canonical.com> <alpine.DEB.2.00.1110192233280.4618@chino.kir.corp.google.com>
 <1319493108.21408.YahooMailNeo@web25602.mail.ukl.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-921260994-1319497957=:3296"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-921260994-1319497957=:3296
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 24 Oct 2011, Sam Tygier wrote:

> >On Thu, 20 Oct 2011, Ike Panhc wrote:
> >
> >> This issue has been reported[1] and patch[2] is ready.
> >> 
> >> [1] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02340.html
> >> 
> >> [2] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02343.html
> >>    http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02346.html
> >> 
> >
> >It certainly looks like the patch in [2] will fix the issue, but it looks 
> >like those are from a couple months ago and I'm still not seeing it in 
> >linux-next.  Matthew, how is this going to Linus and will it be cc'd to 
> >stable@vger.kernel.org?
> 
> 
> the patch works for me (i applied it to kernel between r10 and 3.1 final). for some reason i don't understand i had to apply the patch by hand.
> 

So we can add your

	Tested-by: Sam Tygier <samtygier@yahoo.co.uk>

to the patch.

> i am not quite sure of the etiquette, should I repost the patch in its original form, or my version, or can someone else get this included.
> 

This will go through Matthew's tree and hopefully also backported to 
stable through stable@vger.kernel.org.  Matthew?
--397155492-921260994-1319497957=:3296--
