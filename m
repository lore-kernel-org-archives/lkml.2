Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1BJAA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 19:00:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:50598 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab1BJAA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 19:00:56 -0500
Date: Thu, 10 Feb 2011 11:00:49 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 (EXT-Tieto/Tampere)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena (Nokia-D/Helsinki)" <elena.reshetova@nokia.com>
Subject: Re: Subject: [PATCH] Smack: mmap controls for library containment
In-Reply-To: <4D532703.9060306@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1102101057140.18993@tundra.namei.org>
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com> <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org> <4D52936A.6010407@schaufler-ca.com> <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
 <4D532703.9060306@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Casey Schaufler wrote:

> Shan Wei (1):
>       security:smack: kill unused SMACK_LIST_MAX, MAY_ANY and MAY_ANYWRITE

This one is missing a signoff by you.  You need to use git-am -s

Also, I already have 'Smack: correct behavior in the mmap hook' in my 
tree.  Create a for-security-next (or whatever) branch for me to pull 
from, based on my current tree, without that patch.  (Otherwise I have to 
ask everyone else to rebase).


-- 
James Morris
<jmorris@namei.org>
