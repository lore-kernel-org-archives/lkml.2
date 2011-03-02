Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1CBLXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:23:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1CBLXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tB3nh6Ei2n4lUMWhqefoGCdDjFktI4Xe7dqjXc9Kpt19fCOmjcIDjDqa/B2buTfWE7
         S1ZbZpSzm0hp+mdeHExb7lx54nrl6UzCBiQm/FfPmNmspZTt21IHN8tG6bIEZiCOa+Au
         Eg2haONXZ5lgjg3DpIhSpxcPz9JkPZpWZuQwY=
Date: Wed, 2 Mar 2011 12:23:06 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302112306.GH3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <AANLkTinpVJAsUW83Wu3GNqTzXk=QEamJ=G3N-nrJjJhO@mail.gmail.com>
 <20110302073236.GC19669@htj.dyndns.org>
 <AANLkTikyU27CtRgWW4pbdqL9jVYevazTW-t0XBFJ-EeC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikyU27CtRgWW4pbdqL9jVYevazTW-t0XBFJ-EeC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Mar 02, 2011 at 12:02:37PM +0100, Denys Vlasenko wrote:
> What do you think about SIGSTOP generated in in children on auto-attach
> via PTRACE_O_TRACE[V]FORK / PTRACE_O_TRACECLONE options?

Ah, you're right.  I actually haven't been thinking about them.

> IMHO, it would be good if we'd have a way to distinguish them from
> real SIGSTOP signals.

Yeah, probably.

Thanks.

-- 
tejun
