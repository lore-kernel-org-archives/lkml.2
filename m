Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab2LIPSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:18:10 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33467 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2LIPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:18:08 -0500
Date: Sun, 9 Dec 2012 15:18:04 +0000
From: Cong Ding <dinggnu@gmail.com>
To: JBottomley@parallels.com, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi:gdth.c: fix compilation warning
Message-ID: <20121209151804.GB25293@gmail.com>
References: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping!

- cong

On Mon, Dec 03, 2012 at 10:19:09AM +0000, Cong Ding wrote:
> We do not allow old-style function definition.  Always spell foo(void) if
> a function does not take any parameters.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/scsi/gdth.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 5d72274..950c095 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -204,7 +204,7 @@ static char strbuf[MAX_SERBUF+1];
>  #else
>  #define COM_BASE 0x3f8
>  #endif
> -static void ser_init()
> +static void ser_init(void)
>  {
>      unsigned port=COM_BASE;
>  
> -- 
> 1.7.4.5
> 
