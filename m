Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1CUIAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:00:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25609 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1CUIAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:00:16 -0400
Date: Mon, 21 Mar 2011 08:58:46 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] MAINTAINERS: Add videobuf2 maintainers
In-reply-to: <1300664379-25360-1-git-send-email-pawel@osciak.com>
To: "'Pawel Osciak'" <pawel@osciak.com>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Message-id: <000201cbe79d$d0297250$707c56f0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcvnWBxpC3KZoxLqSUytqEMEVxiUnQARXtPw
References: <1300664379-25360-1-git-send-email-pawel@osciak.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, March 21, 2011 12:40 AM Pawel Osciak wrote:

> Add maintainers for the videobuf2 V4L2 driver framework.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c7a41b1..a5be079 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6665,6 +6665,14 @@ S:	Maintained
>  F:	Documentation/filesystems/vfat.txt
>  F:	fs/fat/
> 
> +VIDEOBUF2 FRAMEWORK
> +M:	Pawel Osciak <pawel@osciak.com>
> +M:	Marek Szyprowski <m.szyprowski@samsung.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/video/videobuf2-*
> +F:	include/media/videobuf2-*
> +
>  VIRTIO CONSOLE DRIVER
>  M:	Amit Shah <amit.shah@redhat.com>
>  L:	virtualization@lists.linux-foundation.org
> --
> 1.7.4.1

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


