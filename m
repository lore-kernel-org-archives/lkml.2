Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0CWL50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0CWL5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:57:25 -0400
Subject: Re: [Cluster-devel] [PATCH 10/18] gfs2: Provide config option for
 enabling trace points
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com
In-Reply-To: <1269304340-25372-11-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-11-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 23 Mar 2010 12:01:07 +0000
Message-ID: <1269345667.2438.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Tue, 2010-03-23 at 01:32 +0100, Jan Kara wrote:
> CC: cluster-devel@redhat.com
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/gfs2/Kconfig      |    8 ++++++++
>  fs/gfs2/trace_gfs2.h |    2 ++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> index 4dcddf8..872ced2 100644
> --- a/fs/gfs2/Kconfig
> +++ b/fs/gfs2/Kconfig
> @@ -38,3 +38,11 @@ config GFS2_FS_LOCKING_DLM
>  	  Most users of GFS2 will require this. It provides the locking
>  	  interface between GFS2 and the DLM, which is required to use GFS2
>  	  in a cluster environment.
> +
> +config GFS2_TRACER
> +	bool "GFS2 tracing"
> +	depends on GFS2_FS && EVENT_TRACING
> +	help
> +	  Provide trace points in block allocation functions, locking, and
> +	  journaling code.
> +
> diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
> index 148d55c..5f4faf3 100644
> --- a/fs/gfs2/trace_gfs2.h
> +++ b/fs/gfs2/trace_gfs2.h
> @@ -1,5 +1,7 @@
>  #undef TRACE_SYSTEM
> +#undef TRACE_CONFIG
>  #define TRACE_SYSTEM gfs2
> +#define TRACE_CONFIG CONFIG_GFS2_TRACER
>  
>  #if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_GFS2_H


