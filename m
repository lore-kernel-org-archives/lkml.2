Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1CGNUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 08:20:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1CGNU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 08:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rcbp7YLAy0o+a86ldvBDkyAJyp9ewCPoNMDJPY7SBPtKgKG6I7P9RJusbMh4wA93gh
         N8QQCTZSyMq24L+xdMeS2P9jn946JR/cgiup7aaAhA7UJg6L0zEX6d3/24QeAhXi7+2C
         AX0M/jzjI4Iguh2kODYO4fVSoaQQZPf55HL9E=
Date: Mon, 7 Mar 2011 14:20:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates, take#2
Message-ID: <20110307132023.GI20499@htj.dyndns.org>
References: <1299321427-15051-1-git-send-email-tj@kernel.org>
 <20110307130332.GA10777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307130332.GA10777@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, Mar 07, 2011 at 02:03:32PM +0100, Oleg Nesterov wrote:
> > The second part, 0007-0010, fixes group stop participation accounting
> > and make tracees always stop in TASK_TRACED instead of TASK_STOPPED.
> > IOW, it implements "P1. Always TASK_TRACED while ptraced" of the
> > proposal.
> 
> Looks like, we already discussed these changes? I mean, at first
> glance the only difference (compared to the previous series) is that
> 10/10 simplifies the usage of task_clear_group_stop_trapping().

Yeah, nothing really changed other than incorporating what you
suggested on the last posting.

> In this case please free to add my reviewed-by or acked-by.

Alright, will add Acked-by's.

> As for "who controls" I do not care too. But I think I should help you
> as much as I can. I'll contact you in a few days to discuss this, but
> let me repeat once again: whatever you prefer is fine for me.

Great, I would need a lot of your help; otherwise, I would be breaking
things left and right.  :-)

Thank you.

-- 
tejun
