Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0KALEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 07:04:43 -0400
Received: from kroah.org ([198.145.64.141]:41951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0KALEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 07:04:41 -0400
Date: Mon, 1 Nov 2010 04:05:24 -0700
From: Greg KH <greg@kroah.com>
To: marui <m00150988@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        wangyeqi@huawei.com, Lin Lei <Lin.Lei@huawei.com>
Subject: Re: [PATCH]linux-usb:To resolve the issue that the "option" driver
	is loaded wrongly  when Huawei datacard the PID of which is 0x14AC
	insterted into Linux System.
Message-ID: <20101101110524.GC4746@kroah.com>
References: <001101cb7975$62f77470$ba260b0a@china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101cb7975$62f77470$ba260b0a@china.huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 11:32:18AM +0800, marui wrote:
> From: ma rui <m00150988@huawei.com>
> 1.This patch is based on kernel of 2.6.36
> 2.when huawei datacard with PID 0x14AC is insterted into Linux system, the present kernel will load the "option" driver to all the interfaces. But actually, some interfaces run as other function and do not need "option" driver.    
> 3.In this path, we modify the id_tables, when the PID is 0x14ac ,VID is 0x12d1, Only when the interface's Class is 0xff,Subclass is 0xff, Pro is 0xff, it does need "option" driver. 
> Signed-off-by: ma rui <m00150988@huawei.com>

Thanks for the patch, I'll queue it up.

greg k-h
