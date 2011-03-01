Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab1CARMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:12:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39835 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1CARMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nzqXnEUlndmmSP++kKgrvXJfd/RWZ+c09EpMIUdLsR3X5FTRIWPLiQcwOcmmX6Y8x2
         8Cqb0ig5c0EwMCpdjzd+QzqnNDwVUAipx+9gvzDY7FurwMerB6FwPfHLWLRGuYxulr3q
         QyJUrMAYg3ek2GEGt1oDwpRZ6vdaEhaCTenO4=
Date: Tue, 1 Mar 2011 18:12:33 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110301171233.GC17933@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301170953.GB17933@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 06:09:53PM +0100, Tejun Heo wrote:
> > Do you propose gdb to be chaged so that "continue" command
> > issues PTRACE_CONT only if gdb knows that application is not
> > in jctl stop?
> 
> gdb can do whatever it wants to do but I don't think the above needs
> fixing.

Oh, just in case, I'm not saying gdb shouldn't be improved.  gdb can
definitely take advantage of better ptrace behaviors and do something
more useful.  e.g. informing the user that the task is in group stop
and ask for confirmation for forced resume or something.

-- 
tejun
