Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0FBOGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:06:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55945 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab0FBOGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:06:33 -0400
X-Greylist: delayed 1658 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 10:06:33 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eHhsct/pKxfNMyE8flnrukSWE8vLBjR/xTOCNLk20uyT03WgSCSryMg6jQCUKpo1yx
         zy2CrqPjnm6xDftKosYWCXWzGltvZfjNJStND81BLrKODaTW/QE8tH5xx+y0XIFK0gtY
         wz94/SMqJ2T/pzy7AspHxmGAwHqzcypTLeLjk=
MIME-Version: 1.0
In-Reply-To: <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
References: <cover.1275481997.git.mina86@mina86.com>
	<5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
	<e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
	<785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
	<5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
	<17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
	<381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
	<c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
Date: Wed, 2 Jun 2010 21:38:54 +0800
Message-ID: <AANLkTilQxWGile5T05flssE8MlwI8HffuKd3PUinVvnw@mail.gmail.com>
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF 
	files
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 8:45 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:

> +**** Customising the gadget
> +
> +If you intend to hack the g_multi gadget be advised that rearranging
> +functions will obviously change interface numbers for each of the
> +functionality.  As an effect provided INFs won't work since they have
> +interface numbers hard-coded in them (it's not hard to change those
> +though).

Probably you can show an example of how to add the "&MI_mm"
to the VID/PID.

A good reference here:
http://www.cygnal.org/ubb/Forum9/HTML/001050.html

> +This also means, that after experimenting with g_multi and changing
> +provided functions one should change gadget's vendor and/or product ID
> +so there will be no collision with other customised gadgets or the
> +original gadget.
> +
> +Failing to comply may cause brain damage after wondering for hours why
> +things don't work as intended before realising Windows have cached
> +some drivers information (changing USB port may sometimes help).
> +

This is indeed quite true. However, you may not need to really change
the VID/PID (it will work but not necessary) if you use the nice
usbdeview utility to remove the phantom USB device.
http://www.nirsoft.net/utils/usb_devices_view.html



-- 
Xiaofan http://mcuee.blogspot.com
