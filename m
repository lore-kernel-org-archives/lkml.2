Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0K2WV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:21:58 -0500
Received: from tundra.namei.org ([65.99.196.166]:43197 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab0K2WV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:21:56 -0500
Date: Tue, 30 Nov 2010 09:21:43 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] keys: add missing include file for trusted and encrypted
 keys
In-Reply-To: <1291065604-9113-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1011300921200.26008@tundra.namei.org>
References: <1291065604-9113-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Mimi Zohar wrote:

> This patch fixes the linux-next powerpc build errors as reported by
> Stephen Rothwell.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Tested-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Thanks!

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
