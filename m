Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1BUQ7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:59:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59771 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab1BUQ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K91khwki+/k83S75u432pYuMuJ5eY9ifBNXyymOASsHMZFnPf+B736srNxt0tsZjRO
         Ln7jiqMkNcM95Rwl2JMkyyrsvNWsaiGfDqwq5QPlizGQOcOLw3qgZA5pWxYPeANqe7Qu
         iSkOULtUE+RliC8CF5xT273lfJEa8AwFoO+kA=
Date: Mon, 21 Feb 2011 17:59:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110221165908.GO31267@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com>
 <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
 <20110214200130.GA21559@redhat.com>
 <20110215152448.GL3160@htj.dyndns.org>
 <20110215173149.239601807B7@magilla.sf.frob.com>
 <20110215202747.GA20560@redhat.com>
 <20110218170212.GS21209@htj.dyndns.org>
 <20110218193709.GA9700@redhat.com>
 <20110221162206.GN31267@htj.dyndns.org>
 <20110221164908.GA25803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221164908.GA25803@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Feb 21, 2011 at 05:49:08PM +0100, Oleg Nesterov wrote:
> > BTW, I plan on separating out all ptrace related stuff into a separate
> > struct as it's not used by most tasks anyway, so I don't think we need
> > to be too concerned about several more fields.
> 
> This is funny.
> 
> I already did this change (it even had some review on lkml). And it was
> discussed again (on archer@sourceware.org) a couple of days ago. Yes,
> probably we should finally do this. Unfortunately, this complicates the
> attach-to-all-threads request (new feature), but anyway.

Heh, well, I also have a mostly working patch but hey if you already
did it, all the better.  :-)

-- 
tejun
