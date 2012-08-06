Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2HFVo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:44:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2HFVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:44:26 -0400
Date: Mon, 6 Aug 2012 14:44:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 0/2]
Message-ID: <20120806214423.GC30355@kroah.com>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:21:42PM +0200, Yann Cantin wrote:
> Hi,
> 
> New USB input driver for eBeam devices.
> 
> Currently, only the Luidia eBeam classic projection model is supported.
> Edge model and a NEC interactive video-projector support planned for the
> end of the mounth. 
> 
> Patch 1 to blacklist the device for hid generic-usb.
> 
> Patch 2 is the actual driver.
> 
> Changes from previous :
> - switch to div64_s64 for portable 64/64-bits divisions
> - some cosmetics in device name
> - unused include and def removed
> - variables name changes for readability
> 
> Pending issues :
> - sysfs custom files : need to pass 13 parameters for calibration :
>   choice is between lots of simply-handled, or few with a big sscanf.

sysfs is "one value per file", so use lots of different files please.

greg k-h
