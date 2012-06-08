Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab2FHI3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:29:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2FHI3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:29:31 -0400
Date: Fri, 8 Jun 2012 10:29:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Rob Landley <rob@landley.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] HID: roccat: Renamed roccat_common functions to
 roccat_common2
In-Reply-To: <1337546704.19878.32.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1206081029180.12208@pobox.suse.cz>
References: <1337546704.19878.32.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012, Stefan Achatz wrote:

> Did this to illustrate my understanding of the firmware generations:
> Valo and Kone were 1st generation
> Arvo was externaly developed and lies in the middle
> All others until now are considered 2nd generation
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-arvo.c     |   16 ++++++++--------
>  drivers/hid/hid-roccat-common.c   |   34 +++++++++++++++++-----------------
>  drivers/hid/hid-roccat-common.h   |   10 +++++-----
>  drivers/hid/hid-roccat-isku.c     |    6 +++---
>  drivers/hid/hid-roccat-koneplus.c |   24 ++++++++++++------------
>  drivers/hid/hid-roccat-kovaplus.c |   20 ++++++++++----------
>  drivers/hid/hid-roccat-pyra.c     |   20 ++++++++++----------
>  drivers/hid/hid-roccat-savu.c     |    4 ++--
>  8 files changed, 67 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
> index 093bfad..327f9b8 100644
> --- a/drivers/hid/hid-roccat-arvo.c
> +++ b/drivers/hid/hid-roccat-arvo.c
> @@ -39,7 +39,7 @@ static ssize_t arvo_sysfs_show_mode_key(struct device *dev,
>  	int retval;
>  
>  	mutex_lock(&arvo->arvo_lock);
> -	retval = roccat_common_receive(usb_dev, ARVO_COMMAND_MODE_KEY,
> +	retval = roccat_common2_receive(usb_dev, ARVO_COMMAND_MODE_KEY,

Could you please give it some more descriptive name, that will clearly 
illustrate that the differentiating factor is the firmware 
version/generation?

Thanks,

-- 
Jiri Kosina
SUSE Labs
