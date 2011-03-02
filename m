Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1CBKxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:53:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44626 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab1CBKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mh/srFRh90XqVersR5g+8CllKyCiXRDS53eDUBiJXzzCaEhSY7XUHbrPk+HG9gF2jT
         jwuDgIE4qTEUR1HX6NDbAlryJOlWfkxEUz4CnpuTn2DfCEeey36+i0EN4S46W0v4fT3J
         5T7Cq+cAm70CGI05v2uvLWWRhXoI4qcvSIZ9M=
Date: Wed, 2 Mar 2011 11:53:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Fix distance table handling
Message-ID: <20110302105325.GE3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302104336.GA26381@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302104336.GA26381@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 11:43:36AM +0100, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > >From dcd414c795a28fff6e511d58e4cfd1202323c703 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Wed, 2 Mar 2011 10:54:10 +0100
> 
> Btw., given that you basically took most of Yinghai's fixes, wouldnt it be better to 
> have this as a 'From: Yinghai' commit, with -v2 comments about minor updates you 
> did?

Yeah, this one was on the boundary for me.  I felt that I edited too
much of the original patch to leave Yinghai's From and S-O-B.  Please
don't take it wrong.  I wasn't trying to emphasize my editing but
wasn't sure whether the chain of custody can be maintained after such
edit.  Maybe I should just ask for respin, with which I haven't had a
lot of luck lately.  Eh well, I'll just change it this time.

Thanks.

-- 
tejun
