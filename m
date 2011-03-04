Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab1CDQPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:15:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427Ab1CDQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:15:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vFCFV3C39UOiEDmBlFQn33hRTg00M0KBRpFqr9ThLI8EmnIGSapp/aXWMJfbVPQzwl
         GktK4xiwpntt/UGwDynt+8io945WTGc+iS+mzKcQabk8hbCw4TlnrOZ6PB30oBJ8wt14
         kyl6Ht0awFpBBESkg79+pDAu4LZNksOZ/pogw=
Date: Fri, 4 Mar 2011 17:15:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304161541.GV20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
 <20110304084441.GB20499@htj.dyndns.org>
 <20110304160151.GA23553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304160151.GA23553@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, Mar 04, 2011 at 05:01:51PM +0100, Oleg Nesterov wrote:
> What I meant, I think the exact details can be discussed separately.
> Say, personally I'd prefer 2 different requests, ATTACH && INTERUPT,
> but I think this is very minor, and I agree with everything as long
> as user-space developers do not object. I just tried to avoid the
> discussion of the "cosmetic" details at this point.

Understood.  One thing tho.  Do you think having ATTACH_NO_STOP would
be better?  I think that's a noticeable difference.  To me, it seems
to only complicate things.  If we decide to go for
ATTACH_STOP_WITHOUT_SIDE_EFFECT then the difference between that and
INTERRUPT again becomes really small, so that was the reason why I
proposed to have a unified one.

Thanks.

-- 
tejun
