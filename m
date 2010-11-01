Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750835Ab0KATIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:08:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58684 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0KATIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s4M88e5NoOVAlXDLJaSO8khdaBI++tEzg5RgZ4+U2ZKzf+7tn8dTICvhTurBvZ4YvI
         oJe9jXY8cdQdp7HWotOj1FI9S6a1IQhwNz/ea2nefUu8W4HbEYdKHMRLJVr8cu4H2d6g
         dm4kFkR9IMlzwhhCg2IYf8iq9Q6FagQEVO1dc=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-13-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-13-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:08:35 +0200
X-Google-Sender-Auth: _1LEgKDVsYhInthMe_O2l0oktwk
Message-ID: <AANLkTimdWuFPaxoY5Bts2_oVa2xmvepapmvZmXu21Pb5@mail.gmail.com>
Subject: Re: [PATCH 12/29] Staging: yaffs2: yaffs_list.h: add file
From: Pekka Enberg <penberg@kernel.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 8:41 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> Adding files to yaffs2 directory.
>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_list.h |  127 +++++++++++++++++++++++++++++++++++
>  1 files changed, 127 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_list.h
>
> diff --git a/drivers/staging/yaffs2/yaffs_list.h b/drivers/staging/yaffs2/yaffs_list.h
> new file mode 100644
> index 0000000..145a1c5
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_list.h
> +/*
> + * This file is just holds extra declarations of macros that would normally
> + * be providesd in the Linux kernel. These macros have been written from
> + * scratch but are functionally equivalent to the Linux ones.
> + *
> + */

This header needs to die.
