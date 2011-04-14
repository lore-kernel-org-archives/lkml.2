Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab1DNRlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:41:24 -0400
Received: from kroah.org ([198.145.64.141]:58902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab1DNRlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:41:22 -0400
Date: Thu, 14 Apr 2011 10:40:07 -0700
From: Greg KH <greg@kroah.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        balbi@ti.com,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20110414174007.GA11640@kroah.com>
References: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 04:36:15PM +0300, Tatyana Brokhman wrote:
> This patch implements the infrastructure for the UAS gadget driver.
> The UAS gadget driver registers as a second configuration of the MS
> gadet driver.
> 
> A new module parameter was added to the mass_storage module:
> bool use_uasp. (default = 0)
> If this parameter is set to true, the mass_storage module will register
> with the UAS configuration as the devices first configuration and
> operate according to the UAS protocol.

Ick, I'd _really_ prefer no new kernel module parameters.  It gets messy
and a pain to support and document (see you didn't document it...)

Any way to do this "automatically"?  Or some other way?

thanks,

greg k-h
