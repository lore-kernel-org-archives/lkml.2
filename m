Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab1ETAv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:51:56 -0400
Received: from tundra.namei.org ([65.99.196.166]:36391 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756937Ab1ETAvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:51:55 -0400
Date: Fri, 20 May 2011 10:51:28 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v5 00/21] EVM
In-Reply-To: <1305769890.3304.90.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1105201041000.28923@tundra.namei.org>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>  <20110518172552.6d482c7a.akpm@linux-foundation.org> <1305769890.3304.90.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, Mimi Zohar wrote:

> > Once we have a better understanding of what the feature does and why it
> > does it and how it interfaces with the user, we can start looking at
> > the implementation.
> 
> Much appreciated!

What is the status of potential users of the feature?

I recall that MeeGo were planning to use EVM, but they've since changed 
their security plans.  Do they still plan to use it?  Are any other users 
committing to use EVM?

Also -- this was raised some time back, but I can't find the discussion -- 
what does IMA/EVM provide over disk encryption as a protection against 
offline attacks?

- James
-- 
James Morris
<jmorris@namei.org>
