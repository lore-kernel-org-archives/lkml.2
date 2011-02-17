Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab1BQQt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:49:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61290 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1BQQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:49:56 -0500
Date: Thu, 17 Feb 2011 16:49:52 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] picoxcell_fuse: add support for the picoXcell fuse
 block
Message-ID: <20110217164952.GD941@pulham.picochip.com>
References: <1297092390-10610-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297092390-10610-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 03:26:30PM +0000, Jamie Iles wrote:
> Picochip picoXcell devices contain a fuse block that controls
> aspects of the device such as disabling JTAG, disabling the ARM
> memory controller, secure booting and storing secure keys. This
> driver provides a character device to read and write the fuse
> values and exports the fuse ranges to sysfs.
> 
> Platforms should add a struct picoxcell_fuse_map to the platform
> device platform_data defining all of the fuse ranges and protection
> bits.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Does anyone have any feedback on this driver?

Thanks,

Jamie
