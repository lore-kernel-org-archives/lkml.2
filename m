Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab2KPLmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:42:38 -0500
Received: from ozlabs.org ([203.10.76.45]:49277 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2KPLmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:42:37 -0500
Date: Fri, 16 Nov 2012 22:42:19 +1100
From: Paul Mackerras <paulus@samba.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, michael.neuling@au1.ibm.com
Subject: Re: [PATCH] powerpc, perf: Change PMU flag values representation
 from decimal to hex
Message-ID: <20121116114219.GA5745@bloggs.ozlabs.ibm.com>
References: <1353056344-1392-1-git-send-email-khandual@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353056344-1392-1-git-send-email-khandual@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 02:29:04PM +0530, Anshuman Khandual wrote:
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

That's not a sufficient description of why you are making this
change.  In particular, what is the motivation for and impact of using
LONG_ASM_CONST?

Paul.
