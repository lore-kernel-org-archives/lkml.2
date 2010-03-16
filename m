Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937449Ab0CPGiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:38:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1715 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab0CPGiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:38:20 -0400
Subject: Re: [RESEND][PATCH] intel_txt: add support for S3 memory integrity
 protection within Intel(R) TXT launched kernel (v3)
From: Joe Perches <joe@perches.com>
To: Shane Wang <shane.wang@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, mingo@elte.hu, rjw@sisk.pl,
       pavel@ucw.cz, joseph.cihula@intel.com
In-Reply-To: <1268749871-2521-1-git-send-email-shane.wang@intel.com>
References: <1268749871-2521-1-git-send-email-shane.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 23:38:18 -0700
Message-ID: <1268721498.16849.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -r d2911aa1461d MAINTAINERS
> --- a/MAINTAINERS	Thu Mar 04 09:37:53 2010 -0500
> +++ b/MAINTAINERS	Wed Mar 10 08:18:48 2010 -0500
> @@ -2891,6 +2891,17 @@ F:	Documentation/networking/README.ipw22
>  F:	Documentation/networking/README.ipw2200
>  F:	drivers/net/wireless/ipw2x00/ipw2200.*
>  
> +INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
> +M:	Joseph Cihula <joseph.cihula@intel.com>
> +M:	Shane Wang <shane.wang@intel.com>
> +L:	tboot-devel@lists.sourceforge.net
> +W:	http://tboot.sourceforge.net
> +T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg

The introductory documentation in MAINTAINERS has:
	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
So perhaps that's should be:
T:	hg http://www.bughost.org/repos.hg/tboot.hg


