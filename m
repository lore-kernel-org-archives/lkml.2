Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab2C1JJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:09:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55791 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab2C1JJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:09:11 -0400
Date: Wed, 28 Mar 2012 11:09:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory_failure: Let the compiler add the function name
Message-ID: <20120328090909.GX22197@one.firstfloor.org>
References: <1332843450-7100-1-git-send-email-bp@amd64.org> <alpine.DEB.2.00.1203280018390.16201@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203280018390.16201@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with your change, but I'm not sure these should be pr_info() to 
> start with, these seem more like debugging messages?  I can't see how 
> they'd be useful in standard operation so could we just convert them to be 
> debug instead?

Well it tells why the page recovery didn't work.

Memory recovery is a somewhat obscure path, so it's better to have
full information.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
