Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2IZNcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:32:02 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58351 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab2IZNb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:31:57 -0400
Date: Wed, 26 Sep 2012 06:31:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thirumalesha N <thiru.linux@gmail.com>
Cc: balbi@ti.com, arnd@arndb.de, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: The USB is not working with SM502 Graphics, but working with
 Intel Pc graphics
Message-ID: <20120926133153.GB25454@kroah.com>
References: <CAO1Rv-YjrxViFBEkSbBLB5YEA0eFEgF5DE06Ri3kcuhWKj7-dA@mail.gmail.com>
 <CAO1Rv-Y7b6rmrGtTasKfSPMHdayd-Amc0wMkTEx_4C3ufK8P2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO1Rv-Y7b6rmrGtTasKfSPMHdayd-Amc0wMkTEx_4C3ufK8P2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 03:09:03PM +0530, Thirumalesha N wrote:
> Dear Sir/Madam,
>  
>               I'm testing PMC type SM502 based Graphics card which has usb,
> audio and display interfaces. 
> 
>              I'm using kernel version linux-2.6.21 with redhat enterprise 5.5
> OS.

As you are testing RHEL, please work with Red Hat for this issue, they
are the only ones tha tcan support it, we can't.  Especially as you are
paying for that support, you might as well use it :)

Good luck,

greg k-h
