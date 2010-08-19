Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab0HSAe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:34:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36080 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0HSAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m38xOsk3mN1LmfP+iGtWM77QH66rQ+Bmjz9d2nc62GmVUy69STrjOeIwWY4FhMiF26
         8iD8DBfIXO5BaJ/JBEn9VxVE+syEgWzoHh8qkOf8OzIid7M7Ady4ArvJXMGuA2sSo+WX
         AHkt254TwPytEh8xF+3PiNzSVdSCT2fWt+spY=
Date: Thu, 19 Aug 2010 02:34:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perf callchains updates
Message-ID: <20100819003416.GA5324@nowhere>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 01:46:09AM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic



BTW, I've built tested it on ARM, Sparc64 (thanks Borislav for the pointer),
PowerPC and SH.

And I've runtime tested it on x86-64, Will has runtime tested it on ARM.

Thanks.

