Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1EYQ6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:58:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:61858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab1EYQ6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="7469960"
Date: Wed, 25 May 2011 09:58:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525165803.GB14958@tassilo.jf.intel.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
 <20110525160656.GB25225@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525160656.GB25225@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This can happen if for example the BIOS somehow does not apply the right 
> > microcode to all CPUs. It can also happen if physically different microcode 
> > version CPUs are mixed. In theory people can mix steppings as well.
> 
> In PRACTICE people WILL mix steppings as well.

Yes exactly. I used to have a system with one P3 supporting FXSAVE
and other not :-) I had to fix the kernel back then to support this.
The system worked perfectly fine after the kernel was fixed.

So the check proposed is a bad idea. It would trigger
on real boxes which don't have any obvious problems.

-Andi
