Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595Ab1ETBHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:07:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59139 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199Ab1ETBHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:07:10 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LRH.2.00.1105201041000.28923@tundra.namei.org>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110518172552.6d482c7a.akpm@linux-foundation.org>
	 <1305769890.3304.90.camel@localhost.localdomain>
	 <alpine.LRH.2.00.1105201041000.28923@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 21:07:06 -0400
Message-ID: <1305853626.2528.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 10:51 +1000, James Morris wrote:
> On Wed, 18 May 2011, Mimi Zohar wrote:
> 
> > > Once we have a better understanding of what the feature does and why it
> > > does it and how it interfaces with the user, we can start looking at
> > > the implementation.
> > 
> > Much appreciated!
> 
> What is the status of potential users of the feature?
> 
> I recall that MeeGo were planning to use EVM, but they've since changed 
> their security plans.  Do they still plan to use it?  Are any other users 
> committing to use EVM?
> 
> Also -- this was raised some time back, but I can't find the discussion -- 
> what does IMA/EVM provide over disk encryption as a protection against 
> offline attacks?
> 
> - James

Dave Safford's whitepaper discusses this.
http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf

Mimi


Mimi

