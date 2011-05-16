Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1EPM2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:28:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36053 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1EPM2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WHIMu8LyZBIkkUSdIoxP52/hlsSs70PJP0de+RzkVJvM9tlJU8J63mEFtAwtb73mSw
         KiQiEdIAYjDGJNkfSGedosMyjHjyD1o0Movr5EJ0VeGtO3+fw8qgNLKZZaBTeew5qMLQ
         MgKpXKxKng14pKNChDn8zdPkWUTzsihwQTdio=
Date: Mon, 16 May 2011 14:27:56 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110516122756.GT23665@htj.dyndns.org>
References: <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
 <20110515174722.GA26361@host1.jankratochvil.net>
 <20110516091318.GQ23665@htj.dyndns.org>
 <20110516121116.GB10469@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516121116.GB10469@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, May 16, 2011 at 02:11:16PM +0200, Jan Kratochvil wrote:
> It cannot as various GDB-supported platforms do not support threads properly.
> And you want to have a common codebase to get it will supported.
> 
> Besides that it is a matter of coding style, I perfer "poll() model" even on
> threads-supporting GNU/Linux.

The above wouldn't be linux kernel's top design concerns, right?

> > Anyways, I would recommend using sleeping wait(2)'s for ptrace event
> > tracking.
> 
> You cannot as I described above.

If you prefer that, go ahead.  It's not like new interface is gonna
break that, but I think it's gonna be more fragile.  Well, it
shouldn't be worse than now.

Thanks.

-- 
tejun
