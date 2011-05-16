Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1EPJPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:15:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61811 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1EPJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rRmBSArIWGXY+6IRKn7rJiHwiCXfF+9gtQq8hLCzAIcOt1AOWth/VgpwGdM0HH2FPa
         Dtk+7VNyhu3Cw9ChgPSPQ0rHycCQq3mFOWFEv/y73jwZK4QgMe4I7cRCquzzuuESAAQA
         levLaXHbUZ8hILjRdq6tSdB9GwNc6uo0Mp0aE=
Date: Mon, 16 May 2011 11:15:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: Ptrace documentation, draft #1
Message-ID: <20110516091504.GR23665@htj.dyndns.org>
References: <201105152235.32073.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105152235.32073.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 10:35:32PM +0200, Denys Vlasenko wrote:
> Hi Tejun,
> 
> On Monday 09 May 2011 12:09, Tejun Heo wrote:
> > Hmmm... I was thinking about writing a proper ptrace API doc with
> > example programs under Documentation/.  It's userland visible API so
> > it shouldn't change all that much and the amount of necessary
> > documentation would be too much for comments.
> 
> Since I am not helping you much in kernel ptrace hacking,
> I can at least help you with the docs.

Oh, I love you.  :-)

I'm a bit backed up at the moment but will get to this later this
week.

Thank you very much.

-- 
tejun
