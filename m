Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1KDCF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:05:59 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:44101 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1KDCF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:05:58 -0400
Date: Fri, 4 Nov 2011 03:05:53 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Geoff Thorpe <geoff@geoffthorpe.net>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de
Subject: Re: [PATCH] uio: documentation fixups
Message-ID: <20111104020553.GD2799@local>
References: <1320248684-25191-1-git-send-email-geoff@geoffthorpe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320248684-25191-1-git-send-email-geoff@geoffthorpe.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 11:44:44AM -0400, Geoff Thorpe wrote:
> The 'name' attribute of struct uio_mem wasn't documented, and the note
> about 'kobj' is stale and needs to be changed to 'map'.

Great, thanks for sending a patch instead of just ignoring it.

> 
> Signed-off-by: Geoff Thorpe <geoff@geoffthorpe.net>

Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

> ---
> 
>  I was hacking on some UIO-related code and noticed some minor
>  glitches in the howto. Just sending it along to get it "off my desk",
>  but please feel free to squash this into any other fixes/updates that
>  may be pending.
> 
>  Regards,
>  Geoff
> 
>  Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index bc4a709..8e98e2f 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -533,6 +533,11 @@ Here's a description of the fields of <varname>struct uio_mem</varname>:
>  
>  <itemizedlist>
>  <listitem><para>
> +<varname>const char *name</varname>: Optional. Set this to help identify
> +the memory region, it will show up in the corresponding sysfs node.
> +</para></listitem>
> +
> +<listitem><para>
>  <varname>int memtype</varname>: Required if the mapping is used. Set this to
>  <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
>  card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
> @@ -565,7 +570,7 @@ instead to remember such an address.
>  </itemizedlist>
>  
>  <para>
> -Please do not touch the <varname>kobj</varname> element of
> +Please do not touch the <varname>map</varname> element of
>  <varname>struct uio_mem</varname>! It is used by the UIO framework
>  to set up sysfs files for this mapping. Simply leave it alone.
>  </para>
> -- 
> 1.7.3.4
> 
> 
