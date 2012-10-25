Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895Ab2JYQdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:33:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:41948 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945Ab2JYQdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:33:54 -0400
Date: Thu, 25 Oct 2012 18:33:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tony Luck <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Message-ID: <20121025163348.GC2623@aftab.osrc.amd.com>
References: <1351174667-5098-1-git-send-email-bp@amd64.org>
 <1351174667-5098-2-git-send-email-bp@amd64.org>
 <20121025160741.GB4341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025160741.GB4341@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 09:07:41AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Oct 25, 2012 at 04:17:43PM +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@alien8.de>
> > 
> > ... which, analogous to DEVICE_INT_ATTR provides functionality to
> > set/clear bools. Its purpose is to be used where values need to be used
> > as booleans in configuration context.
> > 
> > Next patch uses this.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Borislav Petkov <bp@alien8.de>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Do you want me to take this through my tree now?  If not, I have no
> objection to it being part of this larger series and go to Linus through
> whatever tree takes it.

Well, in my case it would go through the RAS tree.

And I, like you, don't care which way it goes except maybe that if those
5 patches stay together, there won't be any build issues due to merging
order in linux-next and later Linus' tree if that first patch goes
separately.

But I'm absolutely open to whatever you suggest is best.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
