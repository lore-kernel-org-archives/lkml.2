Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1BIVxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:53:18 -0500
Received: from tundra.namei.org ([65.99.196.166]:44794 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1BIVxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:53:17 -0500
Date: Thu, 10 Feb 2011 08:53:08 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 (EXT-Tieto/Tampere)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena (Nokia-D/Helsinki)" <elena.reshetova@nokia.com>
Subject: Re: Subject: [PATCH] Smack: mmap controls for library containment
In-Reply-To: <4D52936A.6010407@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com> <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org> <4D52936A.6010407@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Casey Schaufler wrote:

> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Applied to
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> >
> 
> James, I made an error and failed to say that this and Shan Wei's clean-up
> should be pulled from git://gitorious.org/smack-next/kernel.git

Please use git-request-pull to generate the message.


-- 
James Morris
<jmorris@namei.org>
