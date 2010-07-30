Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab0G3DyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 23:54:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:39362 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab0G3DyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 23:54:11 -0400
Date: Fri, 30 Jul 2010 13:54:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
In-Reply-To: <20100730120624.f3112742.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1007301353340.8846@tundra.namei.org>
References: <20100730120624.f3112742.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010, Stephen Rothwell wrote:

> Hi James,
> 
> After merging the security-testing tree, today's linux-next build
> (powerpc ppc64_defconfig) failed like this:
> 
> security/Kconfig:144: can't open file "security/apparmor/Kconfig"
> 
> Caused by commit 32bd8e5273c0be4189274ab55c4d16862f0dd87d ("AppArmor:
> Enable configuring and building of the AppArmor security module").  Looks
> like a file was missed.

I don't know how to use git.

Should be fixed now.

> 

-- 
James Morris
<jmorris@namei.org>
