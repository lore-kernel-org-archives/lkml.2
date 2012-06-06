Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2FFOro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:47:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48638 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753018Ab2FFOrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:47:43 -0400
Message-ID: <1338994062.9522.12.camel@joe2Laptop>
Subject: Re: [RESEND PATCH] trivial: treewide: remove extra semicolon added
 by module_init/exit
From: Joe Perches <joe@perches.com>
To: Felipe Balbi <balbi@ti.com>
Cc: trivial@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 06 Jun 2012 07:47:42 -0700
In-Reply-To: <1338991324-7051-1-git-send-email-balbi@ti.com>
References: <1338991324-7051-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 17:02 +0300, Felipe Balbi wrote:
> The definition of module_init() and module_exit()
> already added the final semicolon creating a situation
> where most of our drivers end up with two semicolons
> at the end of every module_init()/module_exit() call.
> 
> To fix that, we add missing semicolons to the places
> which didn't have them and remove the semicolons from
> the definition of module_init/module_exit.
> 
> Patch generated with the following sed script:
> 
> $ sed -i 's/^module_\(init\|exit\)\s*\((\w\+)\)$/module_\1\2;/g' \
> 	$(git ls-files)

I don't think that script works completely.
It doesn't find the module_init in fs/autofs4/init.c


