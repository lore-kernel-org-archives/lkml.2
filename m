Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1DAC3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 22:29:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34208 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1DAC3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 22:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=heiU81EOvKgplir+yHcADYxmdQXb7TCLLjSg0ZtvlcWPqvZV63Q3HQ8vN5fHgxXVd8
         V/VNAniogjh37iCsnR11lcBfyKwyqbQgxA4Lo1I7UMHASKVdoDLQGFZAZMxvPUv4PxNx
         g7CA4h/MQz6HN8Uxbp/EF1AKLcRk0QJ14ceD8=
Subject: Re: [PATCH] MAINTAINERS: add mm/page_cgroup.c into memcg subsystem
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1301624733-6141-1-git-send-email-namhyung@gmail.com>
References: <1301624733-6141-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 11:29:07 +0900
Message-ID: <1301624947.1496.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, add CC's of the maintainers.


2011-04-01 (금), 11:25 +0900, Namhyung Kim:
> AFAICS mm/page_cgroup.c is for memcg subsystem, but it was directed
> only to generic cgroup maintainers. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b4b9cdec370..a19a1b9677a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4121,6 +4121,7 @@ M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	mm/memcontrol.c
> +F:	mm/page_cgroup.c
>  
>  MEMORY TECHNOLOGY DEVICES (MTD)
>  M:	David Woodhouse <dwmw2@infradead.org>


-- 
Regards,
Namhyung Kim


