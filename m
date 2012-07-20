Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2GTNw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:52:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62167 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab2GTNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:52:55 -0400
Date: Fri, 20 Jul 2012 14:52:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Jon Masters <jonathan@jonmasters.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120720135234.GD6947@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <50065E6B.3060602@jonmasters.org>
 <5008445B.2010109@codeaurora.org>
 <5009044E.9060908@jonmasters.org>
 <50096178.9060902@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50096178.9060902@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 02:47:36PM +0100, Christopher Covington wrote:
> On 07/20/2012 03:10 AM, Jon Masters wrote:
> > Unless you enter at EL2 you can never install a hypervisor. That's the
> > reason for the requirement for generally entering at EL2 when possible.
> 
> That brief explanation would make a useful addition to the documentation
> in my opinion.

Note taken ;), we'll add this.

-- 
Catalin
