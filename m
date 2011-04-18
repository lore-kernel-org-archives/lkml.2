Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1DRE2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 00:28:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63797 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1DRE2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 00:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=E1oGEdbnmJLLyUrNd+gaSynhjNGOWLSV/oCS5uvAR7ZyUzRylXaaGDrvDE8Kt1bZJj
         bogY0ek7DaiMJGoBe5p6HgEwgigdxpC9JVCiC3janQBFudY3SOrAnR9MCDI9qeyTGR71
         6wtyWgVNkFpw4seBlU5VJyqfsEnivi7NndN6w=
Date: Mon, 18 Apr 2011 12:28:30 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Subject: Re: [PATCH 1/1] drivers/usb/image/mdc800.c: Remove "typdef enum".
Message-ID: <20110418042828.GA1904@gmail.com>
Mail-Followup-To: Thiago Farina <tfransosi@gmail.com>,
	linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
References: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 07:34:14PM -0300, Thiago Farina wrote:
> Instead use the keyword "enum" where we use it.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/usb/image/mdc800.c |  111 +++++++++++++++++++++----------------------
This is well for me.
>  	NOT_CONNECTED, READY, WORKING, DOWNLOAD
> -} mdc800_state;
> +};
>  
>  
> -/* Data for the driver */
> +/* Data for the driver. */
>  struct mdc800_data
>  {
> -	struct usb_device *	dev;			// Device Data
> -	mdc800_state 		state;
> +	struct usb_device*      dev;                  /* Device Data. */
This should be 'struct usb_device	*dev'. The same as
following. See Documentation/CodingStyle for details.
> +	enum mdc800_state	state;
>  
> -	unsigned int		endpoint [4];
> +	unsigned int		endpoint[4];
>  
> -	struct urb *		irq_urb;
> +	struct urb*             irq_urb;
>  	wait_queue_head_t	irq_wait;
