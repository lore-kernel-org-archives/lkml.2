Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1E0VmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:42:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44508 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab1E0VmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:42:14 -0400
X-Sasl-enc: knWhjjiGC9HIfLQrX1uT5DZ1F5QrFLf0Ne+/06hIIdfK 1306532532
Date: Sat, 28 May 2011 04:30:44 +0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UGF3ZcWC?= Drobek <pawel.drobek@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
        Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
Message-ID: <20110527203044.GC15821@kroah.com>
References: <4DDEC606.4020504@msgid.tls.msk.ru>
 <20110527012022.GF24630@kroah.com>
 <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com>
 <4DDF427E.1030109@msgid.tls.msk.ru>
 <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com>
 <4DDF6917.9060004@msgid.tls.msk.ru>
 <BANLkTi==1WyJNACmoOxcrS6RiJ3w8Ow1zw@mail.gmail.com>
 <20110527100215.GC9272@kroah.com>
 <4DDFA4F5.8060502@msgid.tls.msk.ru>
 <BANLkTinAip5BswLBjxyJ1O_XPnUFq=FUjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinAip5BswLBjxyJ1O_XPnUFq=FUjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 03:24:02PM +0200, Paweł Drobek wrote:
> On weekend i could give you all data which you need to do more precisely
> action. Just write all command should i give.

The output of:
	lsusb -v
is all that we need.

thanks,

greg k-h
