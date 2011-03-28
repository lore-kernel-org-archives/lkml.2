Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1C1QmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:42:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:1638 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1C1QmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,256,1299484800"; 
   d="scan'208";a="672443619"
Date: Mon, 28 Mar 2011 17:18:49 +0100
From: Alan Cox <alan@linux.intel.com>
To: Lu Guanqun <guanqun.lu@intel.com>
Cc: meego-kernel@lists.meego.com, arjan@linux.intel.com,
        fengguang.wu@intel.com, feng.tang@intel.com, michael.fu@intel.com,
        xingchao.wang@intel.com, vinod.koul@intel.com, jeeja.kp@intel.com,
        Jeff Cheng <jeff_cheng@wistron.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ramesh Babu K V <ramesh.babu@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
Message-ID: <20110328171849.76243726@bob.linux.org.uk>
In-Reply-To: <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
	<1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 10:29:20 +0800
Lu Guanqun <guanqun.lu@intel.com> wrote:

> This patch originates from Jeff Cheng's patch to enable the internal
> speaker.
> 
> On Moorestown platform, internal speaker's power line is connected to
> a GPIO line, this information is got from SFI GPIO table, so we need
> set it to 1 to enable the internal speaker, or set it to 0 to disable
> it.
> 
> When we set the output device, we power on or off the internal
> speaker on demand.

This one looks fine to me - just need to figure out the right way to
get the GPIO pin. Really for a PCI device it ought to be coming from
the PCI space. I will talk to Arjan and co about it.

Alan
