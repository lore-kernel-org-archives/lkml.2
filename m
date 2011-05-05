Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1EEUs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:48:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14269 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1EEUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:48:56 -0400
Date: Thu, 5 May 2011 22:42:09 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: J Freyensee <james_p_freyensee@linux.intel.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
In-Reply-To: <1304616467.8860.80.camel@localhost>
Message-ID: <alpine.LNX.2.00.1105052238540.894@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com>  <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com>  <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net> <1304616467.8860.80.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, J Freyensee wrote:

> On Sun, 2011-04-24 at 02:55 +0200, Jesper Juhl wrote:
...
> > 
> >  kbuff is a local variable. What's the point in assigning NULL to it just 
> > before you return? Just get rid of that silly assignment.
> 
> I err on the side of paranoia and default to attempting to use good
> programming practices and rather receiving comments like this, than the
> alternative where I should have assigned something to NULL/0 and I
> introduce a security flaw in the driver/kernel.
> 

That is all well and good, but assigning to a local variable just before 
it goes out of scope is utterly pointless. Nothing can access the variable 
afterwards, so it's value is completely irrelevant at that point.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

