Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1E0GTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:19:45 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:56813 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab1E0GTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:19:44 -0400
Message-ID: <4DDF427E.1030109@msgid.tls.msk.ru>
Date: Fri, 27 May 2011 10:19:42 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIERyb2Jlaw==?= <pawel.drobek@gmail.com>
CC: Greg KH <greg@kroah.com>, Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
References: <4DDEC269.30808@msgid.tls.msk.ru> <4DDEC606.4020504@msgid.tls.msk.ru> <20110527012022.GF24630@kroah.com> <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com>
In-Reply-To: <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.05.2011 09:40, Paweł Drobek wrote:
> I have got device with this ID's and you are right ID2 is usb2 hub id
> but when you put my device into computer with this settings my device
> report it self as gsm modem based on option.ko module. as far i know
> there are no other solution to get working zte 330 on linux.

Can you please provide the information Greg asked?

>     I don't know, Paweł, can you provide the output of 'lsusb -v' for your
>     system where you saw this being a option device instead of a hub?

Namely, `lsusb -v' output from the system when this
modem is inserted.

At least, maybe this device ID should be restricted to
the particular class of devices.  Alternatively, if number
of such devices on the marked is small (google wasn't able
to find any other references), it should be easy to control
it using a custom udev rule that loads `option' driver and
forcibly binds it to this device.  That is, by the way, an
alternative solution to make it work.

But it is curious that ZTE used "wrong" vendor class for
its product.

Thanks!

/mjt
