Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1DYQT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:19:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49185 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1DYQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N091TF1Asiwu+OJ81UXRO+FVxa1dONhmS50Fhy/rQl2tK5g5tWzn3P+ZKN2p3XZ/RJ
         N0bCd+jYgBsiv48s/VZqCg/Dh5anIyiUZYOPMqtjpbv0YgJ4PWVBsqLBjVZiH8+0+hcz
         6Wlqpcym/JN9o7KlgRyBdogKBXl2UBgtpVXLI=
Date: Mon, 25 Apr 2011 18:19:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
 shared/unblocked signals only
Message-ID: <20110425161951.GA30828@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134501.GC15951@redhat.com>
 <20110425105229.GE17734@mtj.dyndns.org>
 <20110425152040.GA14934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425152040.GA14934@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 25, 2011 at 05:20:40PM +0200, Oleg Nesterov wrote:
> > Hmm... @set?  Maybe a name which refelcts its purpose, say @target or
> > @consider would be better?  Also, it would be really great to have
> > docbook function comment describing the parameter.
> 
> OK... May be @which ? but I agree with any naming.

Yeah, @which sounds fine to me.

> This series is already in -mm, I'd like to avoid another resend. So I'll
> send another patch which addresses your comments on top of this series.
> 
> OK?

Why not route through the signal/ptrace tree?  Also, is the tree
included in linux-next now?

Thanks.

-- 
tejun
