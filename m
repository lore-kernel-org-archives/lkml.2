Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab2CMVZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:25:20 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:32920 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758220Ab2CMVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:25:17 -0400
Message-ID: <4F5FBB3B.1090800@xenotime.net>
Date: Tue, 13 Mar 2012 14:25:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] vgaarb.h: fix build warnings
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au> <4F26F2F8.30505@xenotime.net>
In-Reply-To: <4F26F2F8.30505@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 11:43 AM, Randy Dunlap wrote:

This patch is still needed in linux-next of 20120313.


> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build warnings by providing a struct stub since no fields of
> the struct are used:
> 
> include/linux/vgaarb.h:66:9: warning: 'struct pci_dev' declared inside parameter list
> include/linux/vgaarb.h:66:9: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/vgaarb.h:99:34: warning: 'struct pci_dev' declared inside parameter list
> include/linux/vgaarb.h:109:6: warning: 'struct pci_dev' declared inside parameter list
> include/linux/vgaarb.h:121:8: warning: 'struct pci_dev' declared inside parameter list
> include/linux/vgaarb.h:140:37: warning: 'struct pci_dev' declared inside parameter list
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	David Airlie <airlied@linux.ie>
> Cc:	dri-devel@lists.freedesktop.org
> ---
>  include/linux/vgaarb.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20120130.orig/include/linux/vgaarb.h
> +++ linux-next-20120130/include/linux/vgaarb.h
> @@ -47,6 +47,8 @@
>   */
>  #define VGA_DEFAULT_DEVICE     (NULL)
>  
> +struct pci_dev;
> +
>  /* For use by clients */
>  
>  /**
> 



-- 
~Randy
