Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014Ab0HJXE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:04:58 -0400
Received: from kroah.org ([198.145.64.141]:33948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953Ab0HJXEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:04:53 -0400
Date: Tue, 10 Aug 2010 16:02:14 -0700
From: Greg KH <greg@kroah.com>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Support For Magiccard's ENDURA Card printer support.
Message-ID: <20100810230214.GB6400@kroah.com>
References: <AANLkTinrZmt82eegi1n+YCH5eifj_B-h2m-oCwzMHnjF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinrZmt82eegi1n+YCH5eifj_B-h2m-oCwzMHnjF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 02:38:40PM +0530, Prabhu Chawandi wrote:
> Hi All,
>       I have got Magiccard's  ENDURA Card printer, which I am trying
> to use on linux.   Can I get any clues, whether this device is
> supported by Linux kernel.

If it follows the USB printer specification, yes, the kernel supports
it.

Does your device follow that standard?

thanks,

greg k-h
