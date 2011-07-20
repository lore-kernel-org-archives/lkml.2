Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1GTXbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:31:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:58682 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab1GTXbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:31:06 -0400
Date: Thu, 21 Jul 2011 09:31:00 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
cc: rdunlap@xenotime.net, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v2] tpm: Fix compilation warning when CONFIG_PNP is not
 defined
In-Reply-To: <1310994715.28315.0.camel@d941e-10>
Message-ID: <alpine.LRH.2.00.1107210930430.31489@tundra.namei.org>
References: <1310994715.28315.0.camel@d941e-10>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Stefan Berger wrote:

> The is_itpm() function is only accessed from a block surrounded by
> #ifdef CONFIG_PNP. Therefore, also surround it with #ifdef CONFIG_PNP
> and remove the #else branch causing the warning.
> 
> http://lxr.linux.no/#linux+v2.6.39/drivers/char/tpm/tpm_tis.c#L622
> 
> v2:
>  - fixes a previous typo

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
