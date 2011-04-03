Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1DCXbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:31:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64181 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1DCXbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gheiWBqOJWQXh2vPyOeovVZfhUw7db+nO4FXJJlwd886J0BazvVmQqE4ZbQygQhD8T
         JbfXZ9fraBqJH+WpxVyKhJ3JiBwi/MsHzZAMIh9RV0/aYN37D+pPCs1LPOEYTa7/Lr14
         i8KS9KdAOD78/5HOKmYEks05qrhsHsEDWgNzk=
Date: Sun, 3 Apr 2011 16:30:55 -0700
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, cl@linux.com, florian@mickler.org
Subject: Re: [GIT PULL tip:x86/mm] this_cpu_has() changes and phys_to_nid()
 removal
Message-ID: <20110403233055.GB1420@mtj.dyndns.org>
References: <20110401092218.GJ3385@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401092218.GJ3385@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Fri, Apr 01, 2011 at 11:22:18AM +0200, Tejun Heo wrote:
> Please pull from the following git branch to receive five patches.
> Three of them are Christoph's this_cpu_has() patches.  One removes the
> custom x86-64 phys_to_nid() implementation and the last one cleans up
> arch/x86/Kconfig a bit.  HEAD is 3b16651f80 (x86: Clean up memory
> model related configs in arch/x86/Kconfig).
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> As usual, if HEAD doesn't appear, please pull from master.
> 
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> Thanks.
> 
> Christoph Lameter (3):
>       x86: A fast way to check capabilities of the current cpu
>       x86: Use this_cpu_has for thermal_interrupt current cpu
>       acpi throttling: Use this_cpu_has and simplify code current cpu
> 
> Tejun Heo (2):
>       x86-64, NUMA: Remove custom phys_to_nid() implementation
>       x86: Clean up memory model related configs in arch/x86/Kconfig

I added a patch from Florian which removes an unused variable warning
in x86-64 numa_init() when both AMD and ACPI topology configs are
disabled.  It's a rather pointless configuration, but still.

 http://thread.gmane.org/gmane.linux.kernel/1122108

Thanks.

-- 
tejun
