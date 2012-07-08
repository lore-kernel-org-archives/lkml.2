Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab2GHJX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 05:23:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59929 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab2GHJX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 05:23:58 -0400
Date: Sun, 8 Jul 2012 10:23:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 07/36] AArch64: Assembly macros and definitions
Message-ID: <20120708092342.GC3845@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
 <20120707055723.GA26762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120707055723.GA26762@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 06:57:23AM +0100, Greg KH wrote:
> On Fri, Jul 06, 2012 at 10:05:48PM +0100, Catalin Marinas wrote:
> > +++ b/arch/aarch64/include/asm/assembler.h
> > @@ -0,0 +1,143 @@
> > +/*
> > + * Based on arch/arm/include/asm/assembler.h
> > + *
> > + * Copyright (C) 1996-2000 Russell King
> > + * Copyright (C) 2012 ARM Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> 
> You do this in all of your new files, and I have to ask, are you really
> willing to keep up with the office location of the FSF for the next 40+
> years?  I suggest dropping this last paragraph if at all possible.

Good point. Thanks.

-- 
Catalin
