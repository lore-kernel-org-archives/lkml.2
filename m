Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab1JDRp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:45:59 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:45905 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933120Ab1JDRp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:45:58 -0400
Date: Tue, 4 Oct 2011 13:45:48 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kmemleak: Report previously found leaks even after
 an error
Message-ID: <20111004174548.GA16209@elliptictech.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110239.10660.95998.stgit@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929110239.10660.95998.stgit@e102109-lin.cambridge.arm.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-29 12:02 +0100, Catalin Marinas wrote:
> If an error fatal to kmemleak (like memory allocation failure) happens,
> kmemleak disables itself but it also removes the access to any
> previously found memory leaks. This patch allows read-only access to the
> kmemleak debugfs interface but disables any other action.
> 
> Repored-by: Nick Bowler <nbowler@elliptictech.com>

Reported-by: ...

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Cool, I'll try this out.  Kmemleak rarely stays alive for more than a
few days on my desktop before shutting itself down due to an allocation
failure, so this should be really handy.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
