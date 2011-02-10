Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1BJDGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:06:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245Ab1BJDGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:06:37 -0500
Date: Wed, 9 Feb 2011 19:06:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, davem@davemloft.net,
        greg@kroah.com, rdunlap@xenotime.net
Subject: Re: [PATCH]move double quotation marks so that keep MAINTAINERS
 consistent
Message-Id: <20110209190631.f29419ef.akpm@linux-foundation.org>
In-Reply-To: <20110210025133.GA3285@gmail.com>
References: <20110210025133.GA3285@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 10:51:35 +0800 Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:

> Hi us,
>     When i see MAITAINERS, i find an inconsistent double-quotation-marks.
> So i patch for it:) patcher like following.
> 
> Thanks.
> Best Regards.
> Harry Wei.
> 
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index afb6f7c..95ac55c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -139,7 +139,7 @@ S:	Supported
>  F:	drivers/scsi/3w-*
>  
>  53C700 AND 53C700-66 SCSI DRIVER
> -M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> +M:	James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
>  L:	linux-scsi@vger.kernel.org
>  S:	Maintained
>  F:	drivers/scsi/53c700*

I suspect that some mail clients will explode if you provide them with
an unquoted string containing periods.  That would make copy-n-paste
rather a hassle.

