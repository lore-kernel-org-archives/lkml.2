Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1DSHHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:07:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:56424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1DSHHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:07:51 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Wanlong Gao <wanlong.gao@gmail.com>
Subject: Re: [PATCH 1/1] drivers/usb/image/mdc800.c: Remove "typdef enum".
Date: Tue, 19 Apr 2011 09:09:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc2-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org
References: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com> <201104180926.17457.oneukum@suse.de> <4DAC7487.6050204@gmail.com>
In-Reply-To: <4DAC7487.6050204@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104190909.04206.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 18. April 2011, 19:27:35 schrieb Wanlong Gao:
> 2011-4-18 15:26, Oliver Neukum wroted:
> > Am Montag, 18. April 2011, 02:54:16 schrieb Wanlong Gao:
> >>> -
> >>> /***************************************************************************
> >>>        The USB Part of the driver
> >>> ****************************************************************************/
> >>> --
> >>> 1.7.3.2.343.g7d43d
> >>>
> >> Why did you change it ? and why change so many lines ?
> >> It had some thing wrong ?
> >
> > Exactly. This is a driver for legacy hardware. Could you leave it alone
> > unless you fix a real, as in makes a difference to code generation, bug?
> >
> > 	Regards
> > 		Oliver
> Hmm..Maybe he just want to make to code nice . and didn't think as more 
> about this as you .

Yes, I appreciate that, but the number of testers for these devices is low,
but there are still users.

	Regards
		Oliver
