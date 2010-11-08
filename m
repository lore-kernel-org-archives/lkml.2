Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0KHLWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:22:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:24423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0KHLWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:22:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="571291649"
Date: Mon, 8 Nov 2010 06:22:04 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
Message-ID: <20101108112204.GH4173@linux.intel.com>
References: <444316.89210.qm@web31808.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444316.89210.qm@web31808.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 01:05:14PM -0700, Luben Tuikov wrote:
> The reason to do this is to accommodate sending
> different IU types using the existing
> infrastructure.

Applied, with a modified changelog entry ...

>  	struct urb *data_out_urb;
>  	struct list_head list;
>  };
>  
> -/* I hate forward declarations, but I actually have a loop */
>  static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>  				struct uas_dev_info *devinfo, gfp_t gfp);
>  

Except for this spurious chunk.
