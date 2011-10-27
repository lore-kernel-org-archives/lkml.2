Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1J0ULW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:11:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43448 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1J0ULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:11:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=PCI1nDGqLbnfTVlD5K2bmgz5YFQpbrmor534jvWzJJiVdrWXtbTPi3iIHUesoJzN9
	FJOHg1dtAmTM2DkJhfxcA==
Date: Thu, 27 Oct 2011 13:11:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
In-Reply-To: <1319672648.21924.26.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1110271309050.7639@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de> <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com> <1319669467.21924.18.camel@Joe-Laptop> <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com> <1319670886.21924.22.camel@Joe-Laptop>
 <alpine.DEB.2.00.1110261633190.19579@chino.kir.corp.google.com> <1319672648.21924.26.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Joe Perches wrote:

> > I mean it only makes sense if both prefixes exist (otherwise patch and 
> > git-apply will assume it's not a -p0 patch).
> 
> I think we should not care about the prefixes at all,
> only whether or not the patched file exists.
> 

Nack, there's nothing wrong with storing original files that you're 
modifying in a subdirectory with a name of your choice in the kernel tree.  
It doesn't imply a -p0 patch unless both prefixes appear and that's the 
best indication that it appears in both the patch author and patch 
applier's tree whereas the file being modified is ambiguous.
