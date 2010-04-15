Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DOSEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:04:08 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41176 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755243Ab0DOSEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:04:06 -0400
Date: Thu, 15 Apr 2010 20:03:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, zippel@linux-m68k.org
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default
	y
Message-ID: <20100415180353.GE1443@ucw.cz>
References: <20100413025228.GC10860@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413025228.GC10860@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>  config STRICT_DEVMEM
>  	bool "Filter access to /dev/mem"
> +	default y
>  	---help---
>  	  If this option is disabled, you allow userspace (root) access to all
>  	  of memory, including kernel and userspace memory. Accidental
> @@ -20,7 +21,7 @@ config STRICT_DEVMEM
>  	  This is sufficient for dosemu and X and all common users of
>  	  /dev/mem.
>  
> -	  If in doubt, say Y.
> +	  If in doubt, say N.
>

Eek.

So... what is it?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
