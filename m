Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1JRXoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:44:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1JRXod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:44:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Km68OcPY3NvK5GQiNAb/aAuK+yVcvMkjeIoZkICP8Bji+wlTTtnn+PNCgPJg1UGat
	IeqQZmcbwoY13Nb840Taw==
Date: Tue, 18 Oct 2011 16:44:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
In-Reply-To: <4E9D9558.7040705@cam.ac.uk>
Message-ID: <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com>
References: <4E9D9558.7040705@cam.ac.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Jonathan Cameron wrote:

> This started happening when I run checkpatch on pretty much anything.
> 
> triggered by the b in this snipped for example
> 
> 
> diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
> index 3f8d0af..62dc2a8 100644
> --- a/arch/arm/mach-pxa/stargate2.c
> +++ b/arch/arm/mach-pxa/stargate2.c
> @@ -54,6 +54,8 @@
>  #include <linux/mfd/da903x.h>
> 
> 
> Anyone else seeing this or have a clue what the heck is going on?
> 

I don't think anyone can say for sure if they're seeing what you're seeing 
since checkpatch will just complain that this is a corrupt patch.  Could 
you send an actual diff that exhibits the problem?
