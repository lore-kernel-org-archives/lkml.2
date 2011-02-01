Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1BAWMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:12:44 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59203 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab1BAWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:12:43 -0500
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Meelis Roos <mroos@linux.ee>
Cc: linux-parisc@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 16:12:40 -0600
Message-ID: <1296598360.18277.11.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 00:00 +0200, Meelis Roos wrote:
> I have been testing devel kernels on SMP L1000 successfully until 
> 2.6.38-rc2-00324-g70d1f36 included. The testing means booting the new 
> kernel and running aptitude to update to current debian unstable.
> 
> Now I tried 2.6.38-rc3 and got a crash from aptitude on 2 out of 2 
> tries. Maybe aptitude was broken inbetween but it looks like a kernel 
> bug. Retried 2.6.38-rc2-00324-g70d1f36 and that seemed to work fine so 
> it's more likely a kernel problem.
> 
> What additional information can I provide?

Probably a bisection, if you could.  There have been no parisc patches
between -rc2 and -rc3, so it's coming from outside the architecture.

Thanks,

James


