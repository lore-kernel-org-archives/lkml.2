Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0DUSQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:16:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:43220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab0DUSPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:15:55 -0400
Date: Wed, 21 Apr 2010 11:05:52 -0700
From: Greg KH <gregkh@suse.de>
To: fabien.chouteau@gmail.com
Cc: linux-usb@vger.kernel.org, Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Composite framework: Add suspended sysfs entry
Message-ID: <20100421180552.GB24842@suse.de>
References: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 05:38:21PM +0200, fabien.chouteau@gmail.com wrote:
> From: Fabien Chouteau <fabien.chouteau@barco.com>
> 
> 
> Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
> ---
>  drivers/usb/gadget/composite.c |   21 +++++++++++++++++++++
>  include/linux/usb/composite.h  |    1 +
>  include/linux/usb/gadget.h     |    4 ++++
>  3 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 09289bb..a5352f3 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -898,6 +898,18 @@ static void composite_disconnect(struct usb_gadget *gadget)
>  
>  /*-------------------------------------------------------------------------*/
>  
> +static ssize_t composite_show_suspended(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)

As you added a sysfs file, it is required that you also add an entry in
Documentation/ABI/ that describes the file and what it is for.  Please
respin this with that added to the patch.

thanks,

greg k-h
