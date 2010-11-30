Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0K3RhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:37:22 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0K3RhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hBVYkEn/GwHekodDxhszXNJi7pU4EcNL6eTmA8b0uiN3aXYJEyDMuy4uToFoBJtbMA
         xzYp932UaZsr1PdMFn/CCkH/4/WHszoYhHWB1MvqWVQpzEEktTLtNBSfeuqOhg1H3T8L
         LkvUk0QQwzcmqaGfeL/XYrOOKPoL++5dHQFm4=
Date: Tue, 30 Nov 2010 20:37:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, yinghai@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, NMI: add back unknown_nmi_panic and
	nmi_watchdog sysctls
Message-ID: <20101130173716.GB20818@lenovo>
References: <1291068437-5331-1-git-send-email-dzickus@redhat.com> <1291068437-5331-3-git-send-email-dzickus@redhat.com> <20101130131517.GA16372@lenovo> <20101130162044.GB18100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130162044.GB18100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:20:44AM -0500, Don Zickus wrote:
...
> > > +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
> > 
> > This kinda wonders me -- do we have CONFIG_X86_LOCAL_APIC set _without_
> > CONFIG_X86? I mean CONFIG_X86_LOCAL_APIC is per x86, no?
> 
> Probably, I was just copying-n-pasting what was there previously.  I can
> chop it off.
> 
> Cheers,
> Don
> 

ok, lets leave it as is, at least for better bisectability and tune up
after.

  Cyrill
