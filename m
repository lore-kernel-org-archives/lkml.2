Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1CWJCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:02:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1CWJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vSqut2KL5Jq4jjAo0bOpAc9KScWNvl9qYLru5P9Ftd2rvuGp7C4flz96XTv5Iezkdt
         BhC5jktsbo0kdJD27xAvwUf+3cRVtqMNqs0kakJC4fdxrsV0jo6Pdzjef2sOdlbtC9aw
         l8kG+L46Bwj9aUDj8y02E71c+tYh8Uwg0jmyg=
Date: Wed, 23 Mar 2011 09:48:27 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [RFC PATCHSET] ptrace,signal: Fix notifications to the real
 parent while ptraced
Message-ID: <20110323084827.GX12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <20110322131131.GS12003@htj.dyndns.org>
 <20110322205908.GA3585@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322205908.GA3585@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> I'd only ask you to remove ->group_leader from real_parent_is_ptracer()
> (btw, note that wait_consider_task() can use this helper too) although
> this is minor.

Yeah, will also rename the function as suggested.

> > Please let me know when you want the whole series resent.
> 
> Cough. Resent? If you ask me, I think you should just send them to
> Linus while the merge window is opened.

Too late for that.  Let's target the next merge window.

> I am trying to get the account on kernel.org, but until then I hope
> you can flush the pending ptrace-review branches.

I'll set up a branch until you can get your tree up and request
inclusion to linux-next.

> And yes, I bet we missed something and we will need the subsequent
> fixes anyway ;)

Oh yeah, I have no doubt about that.

Thanks.

-- 
tejun
