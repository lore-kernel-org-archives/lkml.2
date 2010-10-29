Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab0J2IMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:12:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab0J2IMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:12:03 -0400
Date: Fri, 29 Oct 2010 10:12:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: intel idle kconfig warning
Message-ID: <20101029081202.GC11149@basil.fritz.box>
References: <20101028122045.GA6774@basil.fritz.box>
 <alpine.LFD.2.00.1010290053530.4117@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010290053530.4117@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 01:03:11AM -0400, Len Brown wrote:
> 
> > include/config/auto.conf:4352:warning: symbol value 'm' invalid for INTEL_IDLE
> > 
> > Some problem with the intel idle Kconfig?
> 
> I'm unable to reproduce this warning.
> 
> Note that CONFIG_INTEL_IDLE has been boolean since 2.6.36.
> It was tristate in 2.6.35.  Is there some sort of stale state
> on your build system?

Hmm yes it went away after cleaning the build dir.

I guess that's a Kbuild bug then that it doesn't handle such changes?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
