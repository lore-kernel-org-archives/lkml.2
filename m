Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab0GHSNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:13:24 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:11777 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326Ab0GHSNX (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Thu, 8 Jul 2010 14:13:23 -0400
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 14:13:23 EDT
Message-Id: <4C369D2B020000230001CA27@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 08 Jul 2010 11:53:15 -0600
From: "Joey Lee" <jlee@novell.com>
To: <axel.lin@gmail.com>
Cc: <mzxreary@0pointer.de>, <rpurdie@linux.intel.com>, <mjg@redhat.com>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] msi-laptop: make struct rfkill_ops const
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel, 

於 四，2010-07-08 於 10:08 +0800，Axel Lin 提到：
> rfkill uses a const struct rfkill_ops pointer.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/msi-laptop.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> index afd762b..05634f8 100644
> --- a/drivers/platform/x86/msi-laptop.c
> +++ b/drivers/platform/x86/msi-laptop.c
> @@ -562,15 +562,15 @@ static int rfkill_threeg_set(void *data, bool blocked)
>  	return 0;
>  }
>  
> -static struct rfkill_ops rfkill_bluetooth_ops = {
> +static const struct rfkill_ops rfkill_bluetooth_ops = {
>  	.set_block = rfkill_bluetooth_set
>  };
>  
> -static struct rfkill_ops rfkill_wlan_ops = {
> +static const struct rfkill_ops rfkill_wlan_ops = {
>  	.set_block = rfkill_wlan_set
>  };
>  
> -static struct rfkill_ops rfkill_threeg_ops = {
> +static const struct rfkill_ops rfkill_threeg_ops = {
>  	.set_block = rfkill_threeg_set
>  };
>  

The patch good to me, do I need Signed-off it?
How can I signed off a patch?


Thank's a lot!
Joey Lee

