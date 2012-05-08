Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2EHQGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:06:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2EHQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:06:44 -0400
Date: Tue, 8 May 2012 09:06:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
Message-ID: <20120508160640.GA11368@kroah.com>
References: <4FA8EF06.6020108@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA8EF06.6020108@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 07:01:42PM +0900, Chanwoo Choi wrote:
> This patchset use Extcon framework in extcon-max8997 driver to control
> external connector instead of max8997-muic driver which is implemented
> with callback function through platform_data to control external connector.
> 
> So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
> the last patch remove previous MAX8997 MUIC
> driver(drivers/misc/max8997-muic.c)
> which support MUIC feature of Maxim MAX8997 with callback function.
> 
> Chanwoo Choi (2):
>   Extcon: add MAX8997 extcon driver
>   misc: MAX8997: Remove max8997-muic driver
> 
>  drivers/extcon/Kconfig          |    8 +
>  drivers/extcon/Makefile         |    1 +
>  drivers/extcon/extcon-max8997.c |  542
> +++++++++++++++++++++++++++++++++++++++

Your patches are line-wrapped and can not be applied.

Please fix your email client (read Documentation/email_clients.txt for
hints) and resend this series.

thanks,

greg k-h
