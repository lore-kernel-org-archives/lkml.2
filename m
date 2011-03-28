Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1C1FvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:51:00 -0400
Received: from kroah.org ([198.145.64.141]:49640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab1C1Fu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:50:58 -0400
Date: Sun, 27 Mar 2011 22:51:21 -0700
From: Greg KH <greg@kroah.com>
To: Lu Guanqun <guanqun.lu@intel.com>
Cc: meego-kernel@lists.meego.com, alan@linux.intel.com, arjan@linux.intel.com,
        fengguang.wu@intel.com, feng.tang@intel.com, michael.fu@intel.com,
        xingchao.wang@intel.com, vinod.koul@intel.com, jeeja.kp@intel.com,
        Jeff Cheng <jeff_cheng@wistron.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ramesh Babu K V <ramesh.babu@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
Message-ID: <20110328055121.GB27949@kroah.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
 <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:29:20AM +0800, Lu Guanqun wrote:
> This patch originates from Jeff Cheng's patch to enable the internal speaker.

I don't understand this, why is it in the changelog entry?

> On Moorestown platform, internal speaker's power line is connected to a GPIO
> line, this information is got from SFI GPIO table, so we need set it to 1 to
> enable the internal speaker, or set it to 0 to disable it.
> 
> When we set the output device, we power on or off the internal speaker on demand.

What happens without this patch?  Is this a feature you are adding to
the driver, or a bugfix?

thanks,

greg k-h
