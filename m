Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2JEPn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:43:27 -0400
Received: from mail.x86-64.org ([217.9.48.20]:48536 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab2JEPnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:43:25 -0400
Date: Fri, 5 Oct 2012 17:43:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005154312.GF24764@aftab.osrc.amd.com>
References: <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
 <20121005142639.GA20065@kroah.com>
 <20121005152948.GC24764@aftab.osrc.amd.com>
 <20121005153706.GA13571@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005153706.GA13571@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 08:37:06AM -0700, Greg Kroah-Hartman wrote:
> So WARN_RATELIMIT was never working properly? If so, how far back does
> it go in kernel releases that this should be fixed?

Since b3eec79b0776e which added it in May 2011. But the only one other
user is net/core/filter.c.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
