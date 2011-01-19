Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1ASRLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:11:07 -0500
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:17998 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1ASRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:11:06 -0500
Message-ID: <4D371B28.8020501@ixiacom.com>
Date: Wed, 19 Jan 2011 09:11:04 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and uio_device_name()
References: <4D366104.1000400@ixiacom.com> <20110119145619.GA17399@local> <4D370654.7020400@ixiacom.com> <20110119163005.GA12979@kroah.com> <4D371A35.5000009@ixiacom.com>
In-Reply-To: <4D371A35.5000009@ixiacom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I wrote:
> I think you're telling me you won't accept either of:
> 
> a. uio_device_name()
> b. uio_device_chrdev()
[ snip ]
> With no sysfs, I cannot think of a way to get hold of the minor number allocated
> to this instance of the Linux UIO device, and without that I can't open() the
> device driver.

Would you consider :

	extern int uio_device_minor(struct uio_info *info);

?

That would allow me to reconstitute the coordinates of the Linux UIO device
instance from a combination of /proc/devices and a uio_device_minor() query.

Earl
