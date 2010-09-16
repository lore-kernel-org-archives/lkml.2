Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0IPI4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0IPI4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:56:19 -0400
Date: Thu, 16 Sep 2010 14:26:08 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: manual merge of the bkl-llseek tree with the rr tree
Message-ID: <20100916085608.GB8159@amit-laptop.redhat.com>
References: <20100915132646.4aef58f8.sfr@canb.auug.org.au>
 <20100916065438.GE2429@amit-laptop.redhat.com>
 <201009161020.01392.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009161020.01392.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Sep 16 2010 [10:20:01], Arnd Bergmann wrote:
> On Thursday 16 September 2010 08:54:39 Amit Shah wrote:
> > Arnd, the device is supposed to be non-seekable so I'll add a
> > nonseekable_open() to the open() call.
> > 
> > So I guess the llseek operation should ne no_llseek instead of
> > noop_llseek.  Will you change that in your patchset?  Should I do that
> > in the patch I'll queue up?
> 
> Yes, I think it's best if you just do both changes in your patch, I'll
> drop this file from my series then.

Great, I'll queue that up.

		Amit
