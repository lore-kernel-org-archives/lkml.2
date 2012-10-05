Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2JETLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:11:32 -0400
Received: from mail.nonattached.net ([193.160.39.60]:58431 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2JETLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:11:30 -0400
X-Greylist: delayed 4607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2012 15:11:30 EDT
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
From: Dan Luedtke <mail@danrl.de>
To: =?UTF-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
In-Reply-To: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 19:54:37 +0200
Message-ID: <1349459677.22620.4.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 20:56 +0900, 김재극 wrote:
> +	__le32 i_atime;			/* Access time */
> +	__le32 i_ctime;			/* inode Change time */
> +	__le32 i_mtime;			/* Modification time */
> +	__le32 i_btime;			/* file creation time*/

It's probably to late, but have you considered using 64 bit timestamps?
In LanyFS we use 64 bit and I'm very interested in reasoning for 32 bit
timestamps.

Regards

Dan

-- 
Dan Luedtke
http://www.danrl.de

