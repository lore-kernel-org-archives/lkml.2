Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1C1QlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:41:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1C1QlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FJwQPzGi0ub/Uaa6wkkurdoQyajepgeyI0WDd2ABZrdfea9W2D7tOWq1hMAQ/U48UL
         8F1bf+7EIWfixi3s12xdirnDMh1v3yPdSrlcdYxICXe1URZxlIBNkzComJeq8y3snxcL
         xVddMCuj7qRmo3oXWXD2PBiFkAEcZeXHjTJws=
Date: Mon, 28 Mar 2011 18:40:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 3/3] acpi throttling: Use this_cpu_has and
 simplify code current cpu
Message-ID: <20110328164039.GF6736@htj.dyndns.org>
References: <20110312115010.GC2005@htj.dyndns.org>
 <20110312115046.GD2005@htj.dyndns.org>
 <20110312115112.GE2005@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312115112.GE2005@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 12:51:12PM +0100, Tejun Heo wrote:
> From: Christoph Lameter <cl@linux.com>
> 
> With the this_cpu_xx we no longer need to pass an acpi
> structure to the msr management code. Simplifies code and improves
> performance.
> 
> NOTE: This code is x86 specific (see #ifdef CONFIG_X86) but not under
>       arch/x86.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---

Ingo, are you planning on picking these up?

Thanks.

-- 
tejun
