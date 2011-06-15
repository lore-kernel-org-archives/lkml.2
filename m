Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1FOCv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:51:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1FOCv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Hsv/nER86KQHJ3Gavda6bxdh/TbZ/rm6/YPzRr8L/E7wJhIU3dzH9ROXfcrCQiiyOd
         O/RurALemzEY5t1y5rOg==
Date: Tue, 14 Jun 2011 19:51:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: cfowler@opsdc.com
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic on OOM
In-Reply-To: <1308105693.2074.361.camel@compaq-desktop>
Message-ID: <alpine.DEB.2.00.1106141947570.8257@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop> <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com> <1308103443.2074.357.camel@compaq-desktop> <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com>
 <1308105693.2074.361.camel@compaq-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Chris Fowler wrote:

> > More supporting evidence is that in the initial report that you said
> > you had seen the panic and "Rebooting in 10 seconds..." 
> 
> There was a long period between when the box became unresponsive and the
> panic happened.

Yes, that may indicate a VM issue that changed between v2.6.33 and v2.6.38 
that caused the oom killer not to get triggered right away.

> I did not time it but I left it alone in the afternoon
> and later that night I saw the panic.  I know the panic was not
> immediate.
> 

I was attempting to diagnose an issue where the machine failed to actually 
reboot after the "Rebooting in 10 seconds..." message.  So the issue is 
that the machine becomes unresponsive for an indefinite period of time 
between invoking your perl script and seeing the panic, or that the 
machine fails to reboot after "Rebooting in 10 seconds..."?
