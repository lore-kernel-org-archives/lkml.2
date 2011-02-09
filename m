Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1BIHvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:51:24 -0500
Received: from tundra.namei.org ([65.99.196.166]:60495 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1BIHvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:51:23 -0500
Date: Wed, 9 Feb 2011 18:51:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 (EXT-Tieto/Tampere)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena (Nokia-D/Helsinki)" <elena.reshetova@nokia.com>
Subject: Re: Subject: [PATCH] Smack: mmap controls for library containment
In-Reply-To: <4D51E188.9090008@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org>
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Casey Schaufler wrote:

> 
> Subject: [PATCH] Smack: correct behavior in the mmap hook
> 
>   The mmap policy enforcement was not properly handling the
>   interaction between the global and local rule lists.
>   Instead of going through one and then the other, which
>   missed the important case where a rule specified that
>   there should be no access, combine the access limitations
>   where there is a rule in each list.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
