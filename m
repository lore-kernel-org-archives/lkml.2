Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab0KATUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:20:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59217 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0KATU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dl2XWb8jfUatnVRWq/gDLgbvJGHK5CosMJOJvut2FESncfSvcUAx4zGiTnjIdznFcJ
         jCfImPbMdRtB+OD2wxeLpMEbAbbkl/wQ5MPAgTkWKxx2PFI8zQxI5Bz3W5vdKDbZ2jqs
         6YhpJ7iGxBX/GpudkIkZ0/2zxDWLuqWuNEKKQ=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-30-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-30-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:20:27 +0200
X-Google-Sender-Auth: 3vsa7bXDuE-yC-drC59c0d_4DuI
Message-ID: <AANLkTinN5ti5T_PnuvfoSXomGR6CKkKU2_fgo8g3urL+@mail.gmail.com>
Subject: Re: [PATCH 29/29] Staging: yaffs2: TODO: Add TODO file
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
> Inital TODO file.
>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/TODO |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/TODO
>
> diff --git a/drivers/staging/yaffs2/TODO b/drivers/staging/yaffs2/TODO
> new file mode 100644
> index 0000000..be6a836
> --- /dev/null
> +++ b/drivers/staging/yaffs2/TODO
> @@ -0,0 +1,6 @@
> +TODO :
> +
> +       * checkpatch.pl fixes
> +       * sparse fixes

 * drop typedefs
 * drop Linux kernel version compatibility macros
 * drop other strange compatibility macros
 * fix formatting with Lindent
