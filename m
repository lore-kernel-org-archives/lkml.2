Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1J0VCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:02:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17471 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1J0VCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:02:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=hIjigJ5cj+6dt5u7EJzBmp2Lx9ihI2hW9JPf5WwmaW4+6R4fKroVlY3ODYpFfvRmR
	JbOUZLjBQj3S+l3M7geMw==
Date: Thu, 27 Oct 2011 14:01:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
In-Reply-To: <1319747342.7969.15.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1110271359170.11325@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de> <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com> <1319669467.21924.18.camel@Joe-Laptop> <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com> <1319670886.21924.22.camel@Joe-Laptop>
 <alpine.DEB.2.00.1110261633190.19579@chino.kir.corp.google.com> <1319672648.21924.26.camel@Joe-Laptop> <alpine.DEB.2.00.1110271309050.7639@chino.kir.corp.google.com> <1319747342.7969.15.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011, Joe Perches wrote:

> It might be better if you would submit patches
> to checkpatch before you nack others.
> 

A patch without a changelog or sign off is not up for consideration to 
merge.
