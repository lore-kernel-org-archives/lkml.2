Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0DUS30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:29:26 -0400
Received: from kroah.org ([198.145.64.141]:34597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab0DUS3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:29:24 -0400
Date: Wed, 21 Apr 2010 11:27:47 -0700
From: Greg KH <greg@kroah.com>
To: YuPing Luo <YuPing.Luo@csr.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: core: workque: workqueue recursion when unplugging usb WCDMA
 modem on 2.6.32 kernel
Message-ID: <20100421182747.GB7876@kroah.com>
References: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:27:55PM -0700, YuPing Luo wrote:
> Hi,
>    I have one ARM11-based board, while upgrading the kernel from 27 to
> 32, got the workqueue recursion warning almost, and the console get
> lost. While the issue can be resolved by applying the patch "[PATCH v2]
> core: workqueue: return on workqueue recursion", and I am still
> struggling to find the root cause. 

Is your console on a usb to serial device?  Or a serial port?

if usb to serial, can you try .33-rc5 and let us know if that solves the
problem?

thanks,

greg k-h
