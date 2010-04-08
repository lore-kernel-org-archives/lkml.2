Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab0DHGKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:10:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25116 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab0DHGKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:10:38 -0400
Date: Thu, 8 Apr 2010 09:10:00 +0300
From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
To: ext Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 7/8] USB: testusb: imported David Brownell's USB
 testing application
Message-ID: <20100408061000.GA7606@esdhcp042221.research.nokia.com>
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
 <a5ed8238af68738effaf1610f4653d98b9435098.1270644740.git.mina86@mina86.com>
 <922265f162fd3b45408c234d0d17e924b6f61671.1270644740.git.mina86@mina86.com>
 <15d6fb76583235c380569d11d904cc0e8d019067.1270644740.git.mina86@mina86.com>
 <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Apr 2010 06:10:07.0005 (UTC) FILETIME=[22E7CCD0:01CAD6E2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If this is going into kernel then..

On Wed, Apr 07, 2010 at 03:41:34PM +0200, ext Michal Nazarewicz wrote:

...

> +       if ((c = open ("/proc/bus/usb/devices", O_RDONLY)) < 0) {
> +               fputs ("usbfs files are missing\n", stderr);
> +               return -1;
> +       }

Is this needed?

> +
> +       /* collect and list the test devices */
> +       if (ftw ("/proc/bus/usb", find_testdev, 3) != 0) {

How about "/dev/bus/usb" instead? Some distributions do not enable
sysfs in their default kernels anymore.

> +               fputs ("ftw failed; is usbfs missing?\n", stderr);
> +               return -1;
> +       }

br,

-- 
heikki
