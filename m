Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0KJAkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:40:17 -0500
Received: from kroah.org ([198.145.64.141]:60355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0KJAkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:40:12 -0500
Date: Tue, 9 Nov 2010 16:36:50 -0800
From: Greg KH <greg@kroah.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Staging: wlan-ng: fix coding style issues in
 prism2mib.c
Message-ID: <20101110003650.GA15206@kroah.com>
References: <1289060607-13840-1-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289060607-13840-1-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 06:23:27PM +0200, Johan Meiring wrote:
> This is a patch to the prism2mib.c file that fixes various coding style
> issues that were found by the checkpatch.pl tool
> 
> Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
> ---
>  drivers/staging/wlan-ng/prism2mib.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
> index d3a06fa..c1276fd 100644
> --- a/drivers/staging/wlan-ng/prism2mib.c
> +++ b/drivers/staging/wlan-ng/prism2mib.c
> @@ -136,7 +136,8 @@ static int prism2mib_fragmentationthreshold(struct mibrec *mib,
>  					    int isget,
>  					    wlandevice_t *wlandev,
>  					    hfa384x_t *hw,
> -					    struct p80211msg_dot11req_mibset *msg,
> +					    struct p80211msg_dot11req_mibset
> +						*msg,

That's really not much better, so let's just leave the original code.

thanks,

greg k-h
