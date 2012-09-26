Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2IZNDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:03:07 -0400
Received: from mail.x86-64.org ([217.9.48.20]:46611 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab2IZNDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:03:06 -0400
Date: Wed, 26 Sep 2012 15:02:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kjwinchester@gmail.com,
        ak@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de
Subject: Re: [PATCH] x86: remove the useless branch in c_start()
Message-ID: <20120926130257.GH17345@aftab.osrc.amd.com>
References: <1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com>
 <506279F8.10704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506279F8.10704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:43:52AM +0800, Michael Wang wrote:
> On 09/19/2012 01:42 PM, Michael Wang wrote:
> > Since 'cpu == -1' in cpumask_next() is legal, no need to handle '*pos == 0'
> > specially.
> > 
> > About the comments:
> > 	/* just in case, cpu 0 is not the first */
> > A test with a cpumask in which cpu 0 is not the first has been done, and it
> > works well.
> 
> Could I get some comments on this patch?

Looks ok to me:

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
