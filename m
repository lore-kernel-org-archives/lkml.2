Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1AFFLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 00:11:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33111 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1AFFLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 00:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d8eTq/GHSszg6lOCJLQd8+V4a72QEUzNUgvQB0V6bZK4wQDCdxu9vNA5WTdx/fJ7yL
         FUSbQCc3PxWg6jsGX1gYKVa+acedugDM3SyDzl3/WEbx+CIsABw7rHKY6vNXqVh4QBws
         tHKYq31fRsa+RvtOgMxOIkkrGBBjouszEdzi0=
Date: Wed, 5 Jan 2011 21:11:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the percpu tree
Message-ID: <20110106051120.GA21315@mtj.dyndns.org>
References: <20110104152105.5cc7c3a9.sfr@canb.auug.org.au>
 <20110104051314.GA6748@mtj.dyndns.org>
 <20110106151815.9e5c2a1e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106151815.9e5c2a1e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Jan 06, 2011 at 03:18:15PM +1100, Stephen Rothwell wrote:
> > My apologies.  I forgot an earlier patch to introduce this_cpu_has()
> > macro.  I've reverted the offending commit.
> 
> But that revert is not in your published for-next branch yet.  I have
> manually reverted that commit for today.

Ah, embarrassing.  I updated for-2.6.38 but forgot to update for-next
accordingly.  Fixed.

Thank you.

-- 
tejun
