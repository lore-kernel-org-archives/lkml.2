Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1EPM4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:56:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab1EPM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h2TcY6vjFIgB9QxqhNe6UyYk2BggHg4HiPVZNReu3pNlM8kHesz9KZ4D5KjC5/vN1L
         CxZ+jBgRXJAGrD+6QOHC37lXBLMhUPrQ+LedwwdCt3DmAzqwMVN/5Iig2DbpZeLvrnwR
         cMTFvV0Z06q5ESIziEjp41bQutBER5CiNuzuQ=
Date: Mon, 16 May 2011 14:56:15 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re:
 [PATCH 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110516125615.GW23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
 <20110515171748.GA25216@host1.jankratochvil.net>
 <20110515172811.GM23665@htj.dyndns.org>
 <20110515200654.GA32659@host1.jankratochvil.net>
 <20110516084350.GO23665@htj.dyndns.org>
 <20110516121711.GC10469@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516121711.GC10469@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 02:17:11PM +0200, Jan Kratochvil wrote:
> On Mon, 16 May 2011 10:43:50 +0200, Tejun Heo wrote:
> > There's distinction between "broken" and "ugly".  If it's ugly but
> > functional, you don't need to "fix" it.
> 
> The final goal is the user experience (such as the users of GDB), nothing else
> matters.  If it is so "ugly" the userland developers fail to use it the
> project as a whole still broken.

To me, it seems the breakage and mountain of workarounds come more
from lack of proper documentation plus the current ptrace + job
control + signal interaction which is really broken.  For example, it
seems nobody really understood how group stop and ptrace interacts and
the different types of traps being used - strace(2) thought the same
signal was being delivered twice.

> > So, I'm gonna push back quite a bit unless it actually compromises
> > functionality or correctness.
> 
> With your position "if it is workaroundable in userland let's make the new
> kernel API broken again" it no longer makes sense to comment on it.  Yes,
> everything is workaroundable but that is usually not the goal of new APIs.

First of all, let's distinguish "broken" and "ugly" properly and
please keep in mind that what's broken is broken but beauty is in the
eyes of the beholder.

Secondly, I'm listening to your comments and will incorporate them, so
please don't give up so easily.

Thank you.

-- 
tejun
