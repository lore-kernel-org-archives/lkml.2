Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1JTFfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:35:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1JTFff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:35:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=w5x8Lg2MmrRrnUagD3Y24/mzxQ2NKjlJmAvAzPUgRwmrWtXO1pbAPslmnog0ct+PX
	sd9ix3vJgxSLiTobDQBEw==
Date: Wed, 19 Oct 2011 22:35:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ike Panhc <ike.pan@canonical.com>, Matthew Garrett <mjg@redhat.com>
cc: Sam Tygier <samtygier@yahoo.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: 3.1rc10 null pointer dereference
 ideapad_backlight_notify_power
In-Reply-To: <4E9F7A25.1060001@canonical.com>
Message-ID: <alpine.DEB.2.00.1110192233280.4618@chino.kir.corp.google.com>
References: <4E9EB1BC.9020709@yahoo.co.uk> <alpine.DEB.2.00.1110191315320.2892@chino.kir.corp.google.com> <4E9F7A25.1060001@canonical.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Ike Panhc wrote:

> This issue has been reported[1] and patch[2] is ready.
> 
> [1] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02340.html
> 
> [2] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02343.html
>     http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02346.html
> 

It certainly looks like the patch in [2] will fix the issue, but it looks 
like those are from a couple months ago and I'm still not seeing it in 
linux-next.  Matthew, how is this going to Linus and will it be cc'd to 
stable@vger.kernel.org?
