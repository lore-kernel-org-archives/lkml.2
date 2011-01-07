Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1AGUhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:37:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63156 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1AGUhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:37:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bIjyrCR3EFnrDS49FiIlcYh6cMnqyuVqI9Hnm9jwd1RkZ1FA8I1Y0oE+fRO7GbMISv
         S1/0l0+YHoTDLuI14Kpl/fqkroGnXmaOxWFbvyWrKT4Fc/5apSY5CJ0KcMzoHaqGhydO
         dOTSlhv0APGbZk+B3uyyjNNO8Sw2iVS1XWIw8=
Date: Fri, 7 Jan 2011 15:37:50 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
Message-ID: <20110107203750.GD7355@mtj.dyndns.org>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D26D3FD020000780002AED9@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Fri, Jan 07, 2011 at 07:51:09AM +0000, Jan Beulich wrote:
> > I like the idea in general, but I think it may collide with Tejun's NUMA 
> > unification patchset for x86, which I assume will another revision once 
> > the merge window for .38 closes?  Or maybe he'd like to merge your patch 
> > with his series and push it as one?
> 
> I would assume that if unification is done, then the command line
> option would become common too. Tejun?

The unification isn't full and the parameter handling hasn't been
moved yet, so yeah, either your patch can go in first and I can
refresh my series on top of it or vice-versa.

Thanks.

-- 
tejun
