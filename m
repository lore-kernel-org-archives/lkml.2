Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1BBKfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:35:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43931 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1BBKfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xo22+lw5udv50JgbG0cmNGLOQ57twucNT2y3r5/t/V0f97h9JlNcbuUxDlQGUsvSdn
         a6DUoRqnWWSMLg8NzrgIRuw4u6qi6OJhQSN2zHZpW9tQ5vnbXIsMkjO0Y3oD9XNcz+WL
         MmMJ9Lt1U/z3IR4sHm14UNk/6R5u5xjr+yg1I=
Date: Wed, 2 Feb 2011 11:35:42 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-ID: <20110202103542.GC24115@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-3-git-send-email-tj@kernel.org>
 <20110128184601.CBF7C180996@magilla.sf.frob.com>
 <20110131103855.GD7459@htj.dyndns.org>
 <20110201102618.GE14211@htj.dyndns.org>
 <20110201134037.GA25392@redhat.com>
 <20110201150727.GP14211@htj.dyndns.org>
 <20110202053144.29748183D88@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202053144.29748183D88@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 09:31:44PM -0800, Roland McGrath wrote:
> > Oleg, Roland, you guys are the maintainers, so how do you guys want to
> > route the patches which have been acked?  As it's likely that there
> > will be quite some number of ptrace patches, it will be better to have
> > a git tree.
> 
> In practice we are never trusted enough with changes in this area to get
> them just pulled from a tree of ours.  They have to go through akpm and
> Linus for individual approval before they get in.  So I see no point in me
> or Oleg maintaining a git tree that won't get merged directly anyway.

Hmm... okay.  Alright, through -mm then.

Thanks.

-- 
tejun
