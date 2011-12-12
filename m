Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1LLRtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:49:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47968 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753381Ab1LLRtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:49:11 -0500
Message-ID: <1323712147.19538.2.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
From: Joe Perches <joe@perches.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Date: Mon, 12 Dec 2011 09:49:07 -0800
In-Reply-To: <4EE63D43.50706@cfl.rr.com>
References: <cover.1322709471.git.psusi@cfl.rr.com>
	 <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com>
	 <4EE0C814.2000807@cfl.rr.com> <20111208151650.GB16934@nb.redhat.com>
	 <4EE0D6E6.9000807@cfl.rr.com> <20111208155844.GA9281@redhat.com>
	 <4EE0E085.8000907@cfl.rr.com> <20111208162847.GB9281@redhat.com>
	 <4EE17815.6050806@cfl.rr.com> <20111212145330.GB29180@redhat.com>
	 <4EE63D43.50706@cfl.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 12:43 -0500, Phillip Susi wrote:
> On 12/12/2011 09:53 AM, Vivek Goyal wrote:
[]
> > - Can we rename BLKPG_RES_PARTITION to BLKPG_RESIZE_PARTITION. It is
> >   easier to read.
> BLKPG_DELETE_PARTITION is also easier to read, but the existing code
> went with DEL.  I prefer to stay consistent with the existing code and
> also use a 3 letter name.

RES is most commonly used for RESOURCE.

If it really needs to be 3 letters, and I don't think
it does, perhaps BLKPG_RSZ_PARTITION

> diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
> index faf8a45..103da38 100644
> --- a/include/linux/blkpg.h
> +++ b/include/linux/blkpg.h
> @@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
>  /* The subfunctions (for the op field) */
>  #define BLKPG_ADD_PARTITION	1
>  #define BLKPG_DEL_PARTITION	2
> +#define BLKPG_RES_PARTITION	3


