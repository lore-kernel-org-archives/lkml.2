Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab0E0WPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:15:09 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44181 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab0E0WPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=buuX3UJKJJ1TCmQatjj6ogyTaPfZW66RADeeBsoOGtdd65pPH86NYs9d4WUJ8slR4O
         twP0ESlz+tm2MkZJ9eCJCMc7ef/hPk0QoEENGIwoJJLZvMxc78rPYmQOEC4HRbggoT+b
         +NSed4zykg22ETzdv1apO5xYEUvMrJCYC+Ulo=
Date: Fri, 28 May 2010 00:15:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: Tracing configuration review
Message-ID: <20100527221503.GD5390@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu> <20100525201259.GA5370@nowhere> <1274821799.9346.17.camel@cndougla-ubuntu> <20100525230656.GD5370@nowhere> <20100527112044.GA2713@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527112044.GA2713@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 04:50:44PM +0530, K.Prasad wrote:
> On Wed, May 26, 2010 at 01:06:57AM +0200, Frederic Weisbecker wrote:
> > On Tue, May 25, 2010 at 05:09:59PM -0400, Chase Douglas wrote:
> > > On Tue, 2010-05-25 at 22:13 +0200, Frederic Weisbecker wrote:
> > > > On Tue, May 25, 2010 at 03:31:46PM -0400, Chase Douglas wrote:
> 
> <snipped>
> 
> > > > IMO, it is deprecated. The perf interface is much more powerful and flexible.
> > > > Prasad, do you agree if I remove this ftrace plugin?
> 
> Sure, go ahead.



Great, I'll do that soon.

Thanks.

