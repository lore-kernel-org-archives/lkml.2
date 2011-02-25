Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1BYPKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:10:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1BYPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tf3/ID4iSmqBN2Y3wr6JAhw7j5zET3yN44GReCLm0qglpits+naSbrWzYPTuU7jR3b
         1Q/0mKKvzEw/l4Z91/UskRrqk4fvgbEzq1Rw3+VqGFRbTgZcZK50yY0X6bVOK3lmbxti
         AqZIQWldGbg5TUSMTwDwIXTCV3yWo3AMBJAoI=
Date: Fri, 25 Feb 2011 16:10:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110225151048.GO24828@htj.dyndns.org>
References: <20110214200130.GA21559@redhat.com>
 <20110215152448.GL3160@htj.dyndns.org>
 <20110215173149.239601807B7@magilla.sf.frob.com>
 <20110215202747.GA20560@redhat.com>
 <20110218170212.GS21209@htj.dyndns.org>
 <20110218193709.GA9700@redhat.com>
 <20110221162206.GN31267@htj.dyndns.org>
 <20110221164908.GA25803@redhat.com>
 <20110221165908.GO31267@htj.dyndns.org>
 <20110223193117.GA3231@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223193117.GA3231@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 23, 2011 at 08:31:17PM +0100, Oleg Nesterov wrote:
> > Heh, well, I also have a mostly working patch but hey if you already
> > did it, all the better.  :-)
> 
> Argh, sorry. If you already have the patch - please send it.
> 
> Otherwise I'll try to refresh the old series, but not before the next week.

Please go ahead and send yours.  Mine still needs to be separated from
other stuff and isn't tested much.

Thanks.

-- 
tejun
