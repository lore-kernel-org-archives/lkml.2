Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1JZXet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:34:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1JZXer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:34:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=mZBLRYXQ2AfvrBfKyq12Qo/qjGRtuK+Sr3f0ymUT9WxKd5lXS1DOa4evbttj/4/x/
	ZfhSRpT0BcVU6nxvGzyAw==
Date: Wed, 26 Oct 2011 16:34:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
In-Reply-To: <1319670886.21924.22.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1110261633190.19579@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de> <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com> <1319669467.21924.18.camel@Joe-Laptop> <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com>
 <1319670886.21924.22.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Joe Perches wrote:

> > So we need a combination of the two approaches then, it makes sense to 
> > only emit the warning if the patched file exists in both prefixes.
> 
> I don't think so.  What about something like:
> 
> $ diff -urN kernel/foo~ kernel/foo > patch
> 
> I think we should only care about the patched file,.
> 

I mean it only makes sense if both prefixes exist (otherwise patch and 
git-apply will assume it's not a -p0 patch).
