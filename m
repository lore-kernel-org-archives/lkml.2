Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1HRC7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:59:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:37445 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab1HRC7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:59:10 -0400
Date: Thu, 18 Aug 2011 12:58:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] evm: add Kconfig TCG_TPM dependency
In-Reply-To: <1313621496-8308-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1108181258440.23874@tundra.namei.org>
References: <1313621496-8308-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011, Mimi Zohar wrote:

> Although the EVM encrypted-key should be encrypted/decrypted using a
> trusted-key, a user-defined key could be used instead. When using a user-
> defined key, a TCG_TPM dependency should not be required.  Unfortunately,
> the encrypted-key code needs to be refactored a bit in order to remove
> this dependency.
> 
> This patch adds the TCG_TPM dependency.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
