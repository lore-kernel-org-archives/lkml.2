Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1FIFSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:18:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55147 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab1FIFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:18:07 -0400
X-Sasl-enc: VKJfZhk+kJoeMVB8n2CwPV8BrfYActd7ZsTqiYRfFo1L 1307596686
References: <20110609145657.96fae0d0.sfr@canb.auug.org.au>
In-Reply-To: <20110609145657.96fae0d0.sfr@canb.auug.org.au>
Mime-Version: 1.0 (iPad Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <7CA9E653-DABC-470C-BCA6-905D6EBF9283@kroah.com>
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
X-Mailer: iPad Mail (8J2)
From: Greg K-H <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the net tree
Date: Wed, 8 Jun 2011 22:17:55 -0700
To: Stephen Rothwell <sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8, 2011, at 9:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> [See summary in patch below.]
> 
> [Hmmm, suddenly allmodconfig is building stuff in staging?  Ah ha!
> Commit fe35a59e16fb ("Staging: remove STAGING_EXCLUDE_BUILD
> option")  Greg, a bit of warning might have been nice :-( ]
> 

Sorry, this is something that Linus asked for and will be going to him
tomorrow with the rest of the staging-linus branch.

greg k-h
