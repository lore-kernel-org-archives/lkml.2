Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2HHDg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:36:58 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:38300 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069Ab2HHDgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:36:33 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Date: Wed, 8 Aug 2012 05:36:22 +0200
Subject: RE: [PATCHv2 3/4] modem_shm: u8500-shm: U8500 Shared Memory Driver
Thread-Topic: [PATCHv2 3/4] modem_shm: u8500-shm: U8500 Shared Memory Driver
Thread-Index: Ac10y/xfzlloTq5wTy+a9cZtBXUvFwAR9/QQ
Message-ID: <F45880696056844FA6A73F415B568C695B0E796A04@EXDCVYMBSTM006.EQ1STM.local>
References: <1344322471-3640-1-git-send-email-arun.murthy@stericsson.com>
 <1344322471-3640-4-git-send-email-arun.murthy@stericsson.com>
 <20120807183925.GD26990@kroah.com>
In-Reply-To: <20120807183925.GD26990@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  drivers/modem_shm/Kconfig                        |    2 +
> >  drivers/modem_shm/Makefile                       |    1 +
> >  drivers/modem_shm/u8500_shm/Kconfig              |   43 +
> >  drivers/modem_shm/u8500_shm/Makefile             |    7 +
> >  drivers/modem_shm/u8500_shm/shrm_char.c          |  895 ++++++++++++
> >  drivers/modem_shm/u8500_shm/shrm_driver.c        |  732 ++++++++++
> >  drivers/modem_shm/u8500_shm/shrm_fifo.c          |  837 ++++++++++++
> >  drivers/modem_shm/u8500_shm/shrm_net.c           |  312 +++++
> >  drivers/modem_shm/u8500_shm/shrm_protocol.c      | 1590
> ++++++++++++++++++++++
> >  include/linux/modem_shm/u8500_shm/shrm.h         |   23 +
> >  include/linux/modem_shm/u8500_shm/shrm_config.h  |  114 ++
> >  include/linux/modem_shm/u8500_shm/shrm_driver.h  |  225 +++
> >  include/linux/modem_shm/u8500_shm/shrm_ioctl.h   |   43 +
> >  include/linux/modem_shm/u8500_shm/shrm_net.h     |   46 +
> >  include/linux/modem_shm/u8500_shm/shrm_private.h |  183 +++
> 
> Why do any of those .h files need to be in include/linux/*?  Shouldn't
> they just be in the same directory as the driver itself?

Can be moved to the same dir. Will do that in the next ver of the patch.

Thanks and Regards,
Arun R Murthy
-------------
