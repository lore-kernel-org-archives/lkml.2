Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1DESh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:37:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65507 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1DEShy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ALaj10NvTV1zrPNEswl8uzu60dkOja9gKJ6bDpEtPnkKYPqoapTVmYEXdhzIMLszSI
         LB1VbXGypwMJFkbwFLqrv9BVsKpEhYWYQyia2+inpJ+FxFeCE+516epZU+ONjhMIG7qT
         6QtqTns7LioP4QBvzrOFn8HdPen20RbKI5p3E=
MIME-Version: 1.0
In-Reply-To: <1302015561-21047-20-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	<1302015561-21047-20-git-send-email-mmarek@suse.cz>
Date: Tue, 5 Apr 2011 20:37:53 +0200
Message-ID: <BANLkTimVbujtDnF7uJNgfT-oPYGBfR7WLA@mail.gmail.com>
Subject: Re: [PATCH 19/34] rt2x00: Drop __TIME__ usage
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 4:59 PM, Michal Marek <mmarek@suse.cz> wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00debug.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index c92db32..66166ef 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -568,7 +568,6 @@ static struct dentry *rt2x00debug_create_file_driver(const char *name,
>        blob->data = data;
>        data += sprintf(data, "driver:\t%s\n", intf->rt2x00dev->ops->name);
>        data += sprintf(data, "version:\t%s\n", DRV_VERSION);
> -       data += sprintf(data, "compiled:\t%s %s\n", __DATE__, __TIME__);
>        blob->size = strlen(blob->data);
>
>        return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
> --
> 1.7.4.1
>
>
