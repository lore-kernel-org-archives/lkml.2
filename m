Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0CYKdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab0CYKdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:33:35 -0400
Subject: Re: [PATCH] GFS2 docs update
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1269511489-22000-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269511489-22000-1-git-send-email-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 25 Mar 2010 10:37:17 +0000
Message-ID: <1269513437.2835.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Thu, 2010-03-25 at 11:04 +0100, Andrea Gelmini wrote:
> Now http://sources.redhat.com/cluster/ is redirected to
> http://sources.redhat.com/cluster/wiki/
> 
> Also fixed tabs in the end.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  Documentation/filesystems/gfs2.txt |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/gfs2.txt b/Documentation/filesystems/gfs2.txt
> index 5e3ab8f..0b59c02 100644
> --- a/Documentation/filesystems/gfs2.txt
> +++ b/Documentation/filesystems/gfs2.txt
> @@ -1,7 +1,7 @@
>  Global File System
>  ------------------
>  
> -http://sources.redhat.com/cluster/
> +http://sources.redhat.com/cluster/wiki/
>  
>  GFS is a cluster file system. It allows a cluster of computers to
>  simultaneously use a block device that is shared between them (with FC,
> @@ -36,11 +36,11 @@ GFS2 is not on-disk compatible with previous versions of GFS, but it
>  is pretty close.
>  
>  The following man pages can be found at the URL above:
> -  fsck.gfs2	to repair a filesystem
> -  gfs2_grow	to expand a filesystem online
> -  gfs2_jadd	to add journals to a filesystem online
> -  gfs2_tool	to manipulate, examine and tune a filesystem
> +  fsck.gfs2		to repair a filesystem
> +  gfs2_grow		to expand a filesystem online
> +  gfs2_jadd		to add journals to a filesystem online
> +  gfs2_tool		to manipulate, examine and tune a filesystem
>    gfs2_quota	to examine and change quota values in a filesystem
>    gfs2_convert	to convert a gfs filesystem to gfs2 in-place
>    mount.gfs2	to help mount(8) mount a filesystem
> -  mkfs.gfs2	to make a filesystem
> +  mkfs.gfs2		to make a filesystem


