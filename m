Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab1E0JE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:04:27 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:41907 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1E0JEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:04:25 -0400
Message-ID: <4DDF6917.9060004@msgid.tls.msk.ru>
Date: Fri, 27 May 2011 13:04:23 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIERyb2Jlaw==?= <pawel.drobek@gmail.com>
CC: Greg KH <greg@kroah.com>, Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
References: <4DDEC269.30808@msgid.tls.msk.ru> <4DDEC606.4020504@msgid.tls.msk.ru> <20110527012022.GF24630@kroah.com> <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com> <4DDF427E.1030109@msgid.tls.msk.ru> <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com>
In-Reply-To: <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.05.2011 11:41, Paweł Drobek пишет:
> ok, but i have to find pcmcia pci card then put it on pc because i sold
> my notebook some time ago.

Which PCMCIA card?  The device at question is USB, not PCMCIA,
that's why we requested lsusb.

Has anyone else seen this device?  For some reason I doubt
it has the indicated USB ID...

Thanks,

/mjt
