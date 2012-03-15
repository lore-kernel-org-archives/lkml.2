Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab2COObQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:31:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56346 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759489Ab2COObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:31:15 -0400
X-IronPort-AV: E=Sophos;i="4.73,591,1325433600"; 
   d="scan'208";a="4543469"
Message-ID: <4F61FCF8.1040304@cn.fujitsu.com>
Date: Thu, 15 Mar 2012 22:30:16 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Rajak, Rishikesh Kumar (FEL/PQSi)" <rishikesh.rajak@hp.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ltp-list@lists.sourceforge.net" <ltp-list@lists.sourceforge.net>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "risrajak@linux.vnet.ibm.com" <risrajak@linux.vnet.ibm.com>
Subject: Re: [LTP] [PATCH] MAINTAINERS: update the maintain-ship of LTP
References: <1331820621-10095-1-git-send-email-gaowanlong@cn.fujitsu.com> <80145D4278C2654ABC4879063FB2FFA9530ACB12@G4W3231.americas.hpqcorp.net>
In-Reply-To: <80145D4278C2654ABC4879063FB2FFA9530ACB12@G4W3231.americas.hpqcorp.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-15 22:29:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-15 22:29:09,
	Serialize complete at 2012-03-15 22:29:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 10:19 PM, Rajak, Rishikesh Kumar (FEL/PQSi) wrote:

> Hi Wanlong,
> 
> Review-By: Rishikesh K Rajak <rishikesh.rajak@hp.com>
> 
> No issue with me. But still I am closely watching this place though my responsibilities have changed.


Thank you for your previous great work, Rishikesh.

Regards,
Wanlong Gao

> 
> Regards
> Rishi
> 
> -----Original Message-----
> From: Wanlong Gao [mailto:gaowanlong@cn.fujitsu.com]
> Sent: Thursday, March 15, 2012 7:40 PM
> To: akpm@linux-foundation.org
> Cc: ltp-list@lists.sourceforge.net; vapier@gentoo.org; linux-kernel@vger.kernel.org; risrajak@linux.vnet.ibm.com
> Subject: [LTP] [PATCH] MAINTAINERS: update the maintain-ship of LTP
> 
> The maintain-ship of LTP is out of date, so update it.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
> Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
> ---
>  MAINTAINERS |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 95e4e43..3e10e6f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4173,12 +4173,14 @@ F:      Documentation/hwmon/ltc4261
>  F:     drivers/hwmon/ltc4261.c
> 
>  LTP (Linux Test Project)
> -M:     Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
> -M:     Garrett Cooper <yanegomi@gmail.com>
> +M:     Shubham Goyal <shubham@linux.vnet.ibm.com>
>  M:     Mike Frysinger <vapier@gentoo.org>
> -M:     Subrata Modak <subrata@linux.vnet.ibm.com>
> +M:     Cyril Hrubis <chrubis@suse.cz>
> +M:     Caspar Zhang <caspar@casparzhang.com>
> +M:     Wanlong Gao <gaowanlong@cn.fujitsu.com>
>  L:     ltp-list@lists.sourceforge.net (subscribers-only)
>  W:     http://ltp.sourceforge.net/
> +T:     git git://github.com/linux-test-project/ltp.git
>  T:     git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
>  S:     Maintained
> 
> --
> 1.7.10.rc1
> 
> 
> ------------------------------------------------------------------------------
> This SF email is sponsosred by:
> Try Windows Azure free for 90 days Click Here
> http://p.sf.net/sfu/sfd2d-msazure
> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list
> 


