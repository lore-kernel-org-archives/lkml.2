Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab2ILQNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:13:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54637 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab2ILQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:13:38 -0400
X-Sasl-enc: ZuU60C5arHg9rn6DRsLgWbEa2CjyBAY2XiYmI8BoW9tJ 1347466418
Date: Wed, 12 Sep 2012 09:13:36 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Jonathan Cameron <jic23@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120912161336.GC7273@kroah.com>
References: <20120912160719.4377f041ac76ddfa13be7df1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912160719.4377f041ac76ddfa13be7df1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 04:07:19PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/hid/hid-sensor-hub.c: In function 'sensor_hub_probe':
> drivers/hid/hid-sensor-hub.c:599:3: error: too few arguments to function 'mfd_add_devices'
> 
> Caused by commit 401ca24fb34a ("HID: sensors: introduce sensor
> framework") interacting with commit 6607bad3d763 ("mfd: core: Push
> irqdomain mapping out into devices") from the mfd tree.
> 
> I have added the following merge fix patch and can carry it as necessary
> (no action is required).

Looks good to me, thanks for this.

greg k-h
