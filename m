Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0KYNhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:37:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0KYNhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:37:15 -0500
Date: Thu, 25 Nov 2010 14:37:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Pavel Machek <pma@sysgo.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdump: update kexec-tools URL and Vivek's email
In-Reply-To: <1290648612-14964-1-git-send-email-horms@verge.net.au>
Message-ID: <alpine.LNX.2.00.1011251437030.18801@pobox.suse.cz>
References: <1290648612-14964-1-git-send-email-horms@verge.net.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Simon Horman wrote:

> Signed-off-by: Simon Horman <horms@verge.net.au>
> ---
>  Documentation/kdump/kdump.txt |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index cab61d8..7a9e0b4 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -65,18 +65,21 @@ Install kexec-tools
>  
>  2) Download the kexec-tools user-space package from the following URL:
>  
> -http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
> +http://kernel.org/pub/linux/utils/kernel/kexec/kexec-tools.tar.gz
>  
>  This is a symlink to the latest version.
>  
>  The latest kexec-tools git tree is available at:
>  
> -git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools.git
> -or
> -http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
> +git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
> +and
> +http://www.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
> +
> +There is also a gitweb interface available at
> +http://www.kernel.org/git/?p=utils/kernel/kexec/kexec-tools.git
>  
>  More information about kexec-tools can be found at
> -http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
> +http://www.kernel.org/pub/linux/utils/kernel/kexec/README.html
>  
>  3) Unpack the tarball with the tar command, as follows:
>  
> @@ -439,6 +442,6 @@ To Do
>  Contact
>  =======
>  
> -Vivek Goyal (vgoyal@in.ibm.com)
> +Vivek Goyal (vgoyal@redhat.com)
>  Maneesh Soni (maneesh@in.ibm.com)

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
