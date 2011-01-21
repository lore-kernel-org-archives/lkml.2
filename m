Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1AUSNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:13:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44940 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1AUSNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jaEIZ2dA7LE5ofXFXZXpR2MnC+Zw+AWdlNCcFBmyDNR9hxjFFK3C5mmhffaEWo0TWe
         d2QprtnFiSFs/FEFg6qHAqJOVr9f+w1DuAkz2J/YbK3zAX44Tm56QHgKj2ufbNBsTUYf
         QTNdr+5KbqFWdC2nHPyFpja7XU5FZt135TNmo=
Date: Fri, 21 Jan 2011 19:12:50 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
Message-ID: <20110121181250.GA22824@htj.dyndns.org>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
 <20110121171133.GI2832@htj.dyndns.org>
 <alpine.DEB.2.00.1101211114530.15692@router.home>
 <20110121172836.GK2832@htj.dyndns.org>
 <alpine.DEB.2.00.1101211139330.15692@router.home>
 <20110121174817.GM2832@htj.dyndns.org>
 <alpine.DEB.2.00.1101211155150.15692@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101211155150.15692@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 11:57:09AM -0600, Christoph Lameter wrote:
> > Hmm?  asm/percpu.h gets included by linux/percpu.h, so it would end up
> > in most .c files.
> 
> The function is defined in arch/x86/include/asm/percpu.h. At least my
> patches here are that way.
> 
> #include "asm/percpu.h" will get you include/asm-generic/percpu.h on
> other arches.

Yeah, I was referring to generic code having visibility to the x86
specific this_cpu op which isn't available on other archs.  I don't
feel too strong about it so if you don't like it, just add a comment.

Thanks.

-- 
tejun
