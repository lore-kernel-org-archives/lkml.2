Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1E0NTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:19:53 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:60827 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1E0NTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:19:50 -0400
Message-ID: <4DDFA4F5.8060502@msgid.tls.msk.ru>
Date: Fri, 27 May 2011 17:19:49 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: =?UTF-8?B?UGF3ZcWCIERyb2Jlaw==?= <pawel.drobek@gmail.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
References: <4DDEC269.30808@msgid.tls.msk.ru> <4DDEC606.4020504@msgid.tls.msk.ru> <20110527012022.GF24630@kroah.com> <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com> <4DDF427E.1030109@msgid.tls.msk.ru> <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com> <4DDF6917.9060004@msgid.tls.msk.ru> <BANLkTi==1WyJNACmoOxcrS6RiJ3w8Ow1zw@mail.gmail.com> <20110527100215.GC9272@kroah.com>
In-Reply-To: <20110527100215.GC9272@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.05.2011 14:02, Greg KH wrote:
> On Fri, May 27, 2011 at 11:06:37AM +0200, Paweł Drobek wrote:
>> dunno, zte mf330 is pcmcia card identified itself as usb device which need to
>> get working pcmcia options from kernel.
> 
> Yes, older devices put a whole USB host controller device on the PCMCIA
> card in order to talk to it properly without having to change their
> hardware design of the modem chip.

So, what's our course of actions now?

I'd suggest to revert this change and deal with this device
again (specifying the device IDs more precisely, like,
including the device class or what it is called in USB
world) when someone will have it for real.

Thanks,

/mjt
