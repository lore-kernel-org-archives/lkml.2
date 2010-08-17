Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0HQFfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:35:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41873 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab0HQFfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:35:01 -0400
Date: Tue, 17 Aug 2010 07:34:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compiler warnings in 2.6.35.2
Message-ID: <20100817053456.GA32714@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Chris Frey <cdfrey@foursquare.net>, linux-kernel@vger.kernel.org
References: <20100817021252.GA17647@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100817021252.GA17647@foursquare.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Frey <cdfrey@foursquare.net>
Date: Mon, Aug 16, 2010 at 10:12:52PM -0400

> Hi,
> 
> When compiling the latest 2.6.35.2 I get a ton of warnings like the
> following.  Similar warnings were present in 2.6.35, and I assumed a
> stable point release may have tackled them already.  But maybe they
> are peculiar to my setup.  Warning below.
> 
> - Chris
> 
> 
> 
>   CC      mm/swap.o
> In file included from include/linux/kobject.h:21,
>                  from include/linux/sched.h:91,
>                  from mm/swap.c:17:
> include/linux/sysfs.h:183: warning: parameter has incomplete type
> /home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
> /home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h:315: warning: asm operand 1 probably doesn't match constraints

Which compiler version are you using?

-- 
Regards/Gruss,
    Boris.
