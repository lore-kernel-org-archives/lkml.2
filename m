Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1CWPqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:46:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1CWPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:46:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Wed, 23 Mar 2011 16:45:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, roger.quadros@nokia.com,
        grant.likely@secretlab.ca
References: <4D79F068.2080009@linaro.org> <20110323150413.GC6284@kroah.com> <4D8A10BF.8010406@linaro.org>
In-Reply-To: <4D8A10BF.8010406@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231645.48390.arnd@arndb.de>
X-Provags-ID: V02:K0:fbmbzCWcj+TojxGFrTn4jfqOTldhgfn22Q05KzNRlAb
 3xBbzhjQULhOx9Mpxpfn/e2XzEIaR4/ugoP/MZ84hufX2+eBrv
 hBE+JrKys93AehWcdzYe0ESUAZcGUmklvbg6HYOrMdZswdyG37
 /hO+QFIsrgaqPDhJbBltSx5AmTcoaoE6GoXwthTyO6dIfl57kl
 4Xe2l6ec1yhNBK/1DKY7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Andy Green wrote:
> > So again, this problem, for this device, has been solved in userspace
> > without any kernel changes needed.  If there are other devices that you,
> 
> Not sure what you mean by 'again', 'solved in userspace' and so on. 
> Your saying: "go away and do it in userspace" is different from it being 
> "solved in userspace" in reality.  The mess it would create in userspace 
> isn't acceptable.  The outcome of this is it's not fixed in the driver 
> nor userspace.

I agree, doing the device naming in user space to solve this problem would
require identifying the board with the particular bug in a table that
is kept by the distro, and we currently don't even have a way to identify
a specific board. I certainly wouldn't want to rely on things like the
recently proposed /sys/devices/socinfo for identifying whether or not we
want to rename a USB ethernet device.

	Arnd
