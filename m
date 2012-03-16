Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768Ab2CPOEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:04:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50546 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab2CPOD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1203161217060.32664@tundra.namei.org>
References: <alpine.LRH.2.02.1203161217060.32664@tundra.namei.org>
Date: Fri, 16 Mar 2012 10:03:55 -0400
Message-ID: <CACLa4puKa8O8g2i05myV4bSEY5DmnjcZrmrAk==mX+iLdcV=ew@mail.gmail.com>
Subject: Re: [GIT] MAINTAINERS: Add Serge as maintainer of capabilities
From: Eric Paris <eparis@parisplace.org>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 9:20 PM, James Morris <jmorris@namei.org> wrote:
> Hi Linus,
>
> Please pull this patch which adds Serge as maintainer of the
> capabilities code, as discussed on lwn and the lsm list.
>
> New capabilities must be signed off by the maintainer, and new uses of any
> capabilities should at be cc'd to the maintainer.
>
>
> The following changes since commit 0c4d0670f6e54f8507c30c01928cc9ff630ca497:
>  Linus Torvalds (1):
>        Merge branch 'akpm' (Andrew's patch-bomb)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
>
> James Morris (1):
>      MAINTAINERS: Add Serge as maintainer of capabilities
>
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> commit 95d16c7211a5166d6e0241ca8c507718bef3c745
> Author: James Morris <james.l.morris@oracle.com>
> Date:   Fri Mar 16 12:05:48 2012 +1100
>
>    MAINTAINERS: Add Serge as maintainer of capabilities
>
>    Add Serge as maintainer of capabilities, per suggestion on LWN:
>    http://lwn.net/Articles/486306/
>
>    Signed-off-by: James Morris <james.l.morris@oracle.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 03e0b48..9c63a43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1721,6 +1721,14 @@ F:       include/linux/can/error.h
>  F:     include/linux/can/netlink.h
>  F:     include/linux/can/platform/
>
> +CAPABILITIES
> +M:     Serge Hallyn <serge.hallyn@canonical.com>
> +L:     linux-security-module@vger.kernel.org
> +S:     Supported
> +F:     include/linux/capability.h
> +F:     security/capability.c
> +F:     security/commoncap.c

You forgot kernel/capability.c

> +
>  CELL BROADBAND ENGINE ARCHITECTURE
>  M:     Arnd Bergmann <arnd@arndb.de>
>  L:     linuxppc-dev@lists.ozlabs.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
