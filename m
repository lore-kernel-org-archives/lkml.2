Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1BJIBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:01:45 -0500
Received: from tundra.namei.org ([65.99.196.166]:54998 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab1BJIBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 03:01:44 -0500
Date: Thu, 10 Feb 2011 19:01:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 (EXT-Tieto/Tampere)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena (Nokia-D/Helsinki)" <elena.reshetova@nokia.com>
Subject: Re: [PULL] Smack: please pull for security-testing next
In-Reply-To: <4D5379DA.2020109@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1102101901280.20298@tundra.namei.org>
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com> <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org> <4D52936A.6010407@schaufler-ca.com> <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
 <4D5379DA.2020109@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Casey Schaufler wrote:

> The following changes since commit 0e0a070d3a47d279de66e08244769556deae2eee:
>   Casey Schaufler (1):
>         Smack: correct behavior in the mmap hook
> 
> are available in the git repository at:
> 
>   git://gitorious.org/smack-next/kernel.git next
> 
> Casey Schaufler (1):
>       Smack: correct final mmap check comparison
> 
> Shan Wei (1):
>       security:smack: kill unused SMACK_LIST_MAX, MAY_ANY and MAY_ANYWRITE

Thanks, looks good :-)


-- 
James Morris
<jmorris@namei.org>
