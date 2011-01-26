Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1AZSET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:04:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53200 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1AZSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=pwfsrzAU2zhIARpVJwPhy4wjxwSvKYzOKtv+WTp7ceQx1qne0Q3QuBBa1jWdtn4Gmw
         BLZ4Kb0JPZ+FHpeTV1lSERou7rC7NZF+6FGI4RDk6BlLI0PFBJXfRyahgS3IeGeqg3yj
         gXR3AjEWABlTMdBiXjGuAnGQRCQKWzPo61Bdk=
Date: Wed, 26 Jan 2011 21:04:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 7/8] staging: hv: Convert camel cased struct fields in
 vmbus_packet_format.h to lower cases
Message-ID: <20110126180400.GS2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, hjanssen@microsoft.com,
	gregkh@suse.de, linux-kernel@vger.kernel.org,
	devel@linuxdriverproject.org, virtualization@lists.osdl.org
References: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-2-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-3-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-6-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-7-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296064206-11372-7-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 09:50:05AM -0800, Haiyang Zhang wrote:
> +	VM_PKT_INVALID				= 0x0,
> +	VM_PKT_SYNCH				= 0x1,
> +	VM_PKT_ADD_XFER_PAGESET		= 0x2,
> +	VM_PKT_RM_XFER_PAGESET		= 0x3,
                                          ^^^^
> +	VM_PKT_ESTABLISH_GPADL			= 0x4,
> +	VM_PKT_TEARDOWN_GPADL			= 0x5,
> +	VM_PKT_DATA_INBAND			= 0x6,
> +	VM_PKT_DATA_USING_XFER_PAGES		= 0x7,
> +	VM_PKT_DATA_USING_GPADL			= 0x8,
> +	VM_PKT_DATA_USING_GPA_DIRECT		= 0x9,
> +	VM_PKT_CANCEL_REQUEST			= 0xa,
> +	VM_PKT_COMP			= 0xb,
                                        ^^^^^^
> +	VM_PKT_DATA_USING_ADDITIONAL_PKT	= 0xc,
> +	VM_PKT_ADDITIONAL_DATA			= 0xd


These don't line up with the others.

regards,
dan carpenter
