Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2HVNps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:45:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52721 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2HVNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:45:46 -0400
Date: Wed, 22 Aug 2012 21:45:19 +0800
From: Adam Lee <adam8157@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "open list:KCONFIG" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] [Signed-off] kconfig: document oldnoconfig to what it
 really does in conf.c
Message-ID: <20120822134519.GA5639@adam-laptop>
References: <1345186649-17502-1-git-send-email-adam8157@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345186649-17502-1-git-send-email-adam8157@gmail.com>
X-PGP-Key-ID: 2F39D84D
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 02:57:28PM +0800, Adam Lee wrote:
> As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, the make target
> 'oldnoconfig' is a misnomer. It doesn't set new symbols to 'n', but
> instead sets it to their default values.
> 
> This patch fixes the document in conf.c, and will submit another patch
> to replace 'oldnoconfig' to 'olddefconfig'
> 
> Signed-off-by: Adam Lee <adam8157@gmail.com>
> ---
>  scripts/kconfig/conf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hi,

I think we should apply this patch, any comment?

I was confused by the different documents of `make help` and usage of
"scripts/kconfig/conf.c" before I got through conf.c and checked the git
log. Others maybe confused too. So I think we really should apply this
patch at least.

As regards whether that target should be renamed to 'olddefconfig', we
can discuss it at another thread.

Thank you.

-- 
Regards,
Adam Lee
http://adam8157.info
