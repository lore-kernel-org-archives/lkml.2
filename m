Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1FYNwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 09:52:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45191 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1FYNwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 09:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EqfHrXNx/1Teb16JQgCYCBF0e2s26MkP8bbxQTYw0/0xCxZhH3KhXDXPfruDKZEbxr
         lOeDw+t/bPxqt2kSmVs2UxE9MrKsVRXzbEjc6iG3C5QDO/sU9Y4xcgamXnMz08lCIVSb
         g5GUG6zS4RC2iNEWZ3GD0AgCjg4ziiw1dI1Q0=
Date: Sat, 25 Jun 2011 15:52:05 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ptrace: wait_consider_task:
 s/same_thread_group/ptrace_reparented/
Message-ID: <20110625135205.GW30101@htj.dyndns.org>
References: <20110624153330.GA9346@redhat.com>
 <20110624153439.GD9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624153439.GD9346@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 05:34:39PM +0200, Oleg Nesterov wrote:
> wait_consider_task() checks same_thread_group(parent, real_parent),
> this is the open-coded ptrace_reparented().
> 
> __ptrace_detach() remains the only function which has to check this by
> hand, although we could reorganize the code to delay __ptrace_unlink.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
