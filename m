Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052Ab0HMBbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:31:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51465 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab0HMBba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:31:30 -0400
Date: Thu, 12 Aug 2010 18:30:59 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Cloning arch-independant KConfig
Message-ID: <20100813013059.GJ22777@mail.oracle.com>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org
References: <20100812233837.GG22777@mail.oracle.com>
 <20100813012052.GA2079@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813012052.GA2079@merkur.ravnborg.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 03:20:52AM +0200, Sam Ravnborg wrote:
> Today there are a few ways you can do so already.
> Say that you have saved away the known good one as "good", which is
> a direct copy of your .config.
> 
> Then you can do for example:
> KCONFIG_ALLCONFIG=good make alldefconfig
> 
> This will produce a config wich is almost equal to what you had before,
> and with defaults for all new stuff.
> I tested it where I used a sparc defconfig as input to a i386
> config and it just worked.

	That seems pretty reasonable.

> cat .config good > new
> mv new .config
> make menuconfig
> 
> This will trigger a lot of override warnings - which you just ignore.
> Resulting config is then mostly from "good".

	The problem with this, which I've definitely done before, is I
never know what paths in menuconfig to look down.  The alldefconfig
choice seems saner because it provides a dirt-simple CPU setup.

Joel

-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
