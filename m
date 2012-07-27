Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2G0WaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:30:13 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54274 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751709Ab2G0WaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:30:10 -0400
Message-ID: <5013162C.9030606@xenotime.net>
Date: Fri, 27 Jul 2012 15:29:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Documentation: fix DOCBOOKS=... building
References: <1339577020.4519.19.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339577020.4519.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 01:43 AM, Johannes Berg wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Prior to 
> commit 4266129964b8238526936d723de65b419d8069c6
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Tue May 31 16:27:44 2011 -0300
> 
>     [media] DocBook: Move all media docbook stuff into its own directory
> 
> it was possible to build only a single (or more)
> book(s) by calling, for example
> 	make htmldocs DOCBOOKS=80211.xml
> 
> This now fails:
> cp: target `.../Documentation/DocBook//media_api' is not a directory
> 
> Ignore errors from that copy to make this possible again.
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I complained about this a long time ago, but now it finally bothered me
> enough to fix it ... :-)


Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Mauro??


> 
>  Documentation/DocBook/media/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/Documentation/DocBook/media/Makefile	2012-06-13 10:39:58.000000000 +0200
> +++ b/Documentation/DocBook/media/Makefile	2012-06-13 10:40:05.000000000 +0200
> @@ -195,7 +195,7 @@ DVB_DOCUMENTED = \
>  #
>  
>  install_media_images = \
> -	$(Q)cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
> +	$(Q)-cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
>  
>  $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
>  	$(Q)base64 -d $< >$@
> 
> 



-- 
~Randy
