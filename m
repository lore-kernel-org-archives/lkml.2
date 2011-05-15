Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab1EORBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:01:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1EORBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hXuuwGQKu9rWcYP6KX0GR1HMcZKR8jzCjqRbcxodt/TUo+WYKnuTnXIticFMwkSdkI
         aKjT9/g2m1T6e6MbJBpx9moL8fnsGjwrNeJuHlTS9u6EQ+5qYktHS28P4asIAx0N02+I
         rF0Fnp5/5hAv5F1As3COaPyaL11TnzNbsKz/s=
Date: Sun, 15 May 2011 19:01:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110515170139.GJ23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515164705.GI23665@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

BTW, I'm pretty close to send the second take and the INTERRUPT trap
has changed quite a bit.  It got renamed to PTRACE_EVENT_STOP and now
acts as both group stop trap and INTERRUPT trap.  IOW,
PTRACE_INTERRUPT makes tracee go park at group stop trap site.  The
whole thing is much prettier this way.  Well, being ptrace, it's not
really pretty but at least it is much less disgusting.

Thanks.

-- 
tejun
