Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1BWJke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:40:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58631 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1BWJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:40:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mViLBV7NypVHnDoy2ylRh0z42t8074CI5G/CqQ5gSG65Iz96oXMKT6/Y0PZIhutOzI
         jMJOyBeB/SPDWEgMq2uaH9W57twmr32cEZYl43P+Q674KEx4851+m4ba+ufZkyqk5pBA
         LczenA4C67D4kiIBVkcYUtasCvJpTgX0Wyoj8=
Date: Wed, 23 Feb 2011 17:40:22 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] MAINTAINERS: Trivial corrections
Message-ID: <20110223094020.GA3090@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <cover.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1298439175.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:41:53PM -0800, Joe Perches wrote:
> Various trivial fixes to MAINTAINERS, updated patterns and such.
> 
> Joe Perches (18):
>   MAINTAINERS: Update ADP5520 pattern
>   MAINTAINERS: Change web links from wiki-analog to wiki.analog
>   MAINTAINERS: Remove ASOC CODEC DRIVERS files not in tree
>   MAINTAINERS: Add missing : after HR Timers F tag
>   MAINTAINERS: Remove unnecessary linux-kernel@vger.kernel.org entries
>   MAINTAINERS: Update clkdev location
>   MAINTAINERS: Update media path
>   MAINTAINERS: Update HVC file patterns
>   MAINTAINERS: Quote non-alphanumeric email addresses
>   MAINTAINERS: Remove unused clockevents.h
>   MAINTAINERS: Remove IEEE1394 entry
>   MAINTAINERS: Remove unused TIMEKEEPING timekeeping.h
>   MAINTAINERS: Update SCX200 file pattern
>   MAINTAINERS: Remove SHARP LH7A40X section
>   MAINTAINERS: Update SFI pattern
>   MAINTAINERS: Update TIPC patterns
>   MAINTAINERS: USB SE401 moved to staging, update pattern
>   MAINTAINERS: Update WINBOND CIR pattern
Hi Joe,
	So wonderful :)
	Thanks for us to fix some issues.
	In fact, i have found some of yours in MAINTAINERS  but have not patched yet ;)

	Thanks.
	Best Regards.
	Harry Wei.

> 
>  MAINTAINERS |   82 ++++++++++++++++++-----------------------------------------
>  1 files changed, 25 insertions(+), 57 deletions(-)
> 
> -- 
> 1.7.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
