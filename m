Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1JZGrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:47:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1JZGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:47:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=yrbXf9Vs70gJhyW2PeWrT+vJ+fYKa2BcJk/T2cnEblgQg4Z3VdJ/p6/9dCbbPsZCc
	NNV3qAFQi/FzPpk/zpAIA==
Date: Tue, 25 Oct 2011 23:47:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eial Czerwacki <eial@scalemp.com>
cc: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] APICID: Avoid false sharing on the read mostly
 x86_cpu_to_apicid
In-Reply-To: <4EA7AB7C.9080703@scalemp.com>
Message-ID: <alpine.DEB.2.00.1110252345260.20273@chino.kir.corp.google.com>
References: <4EA66960.7050907@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274367@VMBX108.ihostexchange.net> <4EA6A265.1080506@scalemp.com> <alpine.DEB.2.00.1110252318090.20273@chino.kir.corp.google.com> <4EA7AB7C.9080703@scalemp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Eial Czerwacki wrote:

> >> Signed-off-by: Eial Czerwacki<eial@scalemp.com>
> >> Signed-off-by: Shai Fultheim<shai@scalemp.com>
> >> Author: Ravikiran Thirumalai<kiran@scalex86.org>
> > 
> > If the author isn't you, then the patch should start with a single line 
> > that says "From: name <email>" of the author followed by a blank line.  
> > It's also strange that the author doesn't have a sign-off line.
> > 
> 
> 
> the author is mentioned after the last sign-off.
> 

That's not the way it's done, as I said, the patch needs to start with a 
single line like this:

From: Ravikiran Thirumalai <kiran@scalex86.org>

...

and if that person signed it off, then it needs to appear as

Signed-off-by: ...

as the first one in the chain.  Please see part 15 of section 1 of 
Documentation/SubmittingPatches.
