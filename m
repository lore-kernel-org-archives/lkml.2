Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0CYWhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:37:01 -0400
Received: from tundra.namei.org ([65.99.196.166]:51625 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0CYWg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:36:59 -0400
Date: Fri, 26 Mar 2010 09:36:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: safford@watson.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TPM: workaround to enforce PCR updates across suspends
In-Reply-To: <1269489332.12676.14.camel@blackbox.ibm.com>
Message-ID: <alpine.LRH.2.00.1003260936460.11663@tundra.namei.org>
References: <1269489332.12676.14.camel@blackbox.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Rajiv Andrade wrote:

> Add a workaround for TPM's which fail to flush last written
> PCR values in a TPM_SaveState, in preparation for suspend.
> 
> Signed-off-by: David Safford <safford@watson.ibm.com>
> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
