Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab1E0KDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 06:03:00 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48115 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab1E0KC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 06:02:58 -0400
X-Sasl-enc: kdUYUAve6Me7sKOn18j9KkTSeRyniz7mBt1M5ZkW2nRq 1306490576
Date: Fri, 27 May 2011 18:02:15 +0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UGF3ZcWC?= Drobek <pawel.drobek@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
        Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
Message-ID: <20110527100215.GC9272@kroah.com>
References: <4DDEC269.30808@msgid.tls.msk.ru>
 <4DDEC606.4020504@msgid.tls.msk.ru>
 <20110527012022.GF24630@kroah.com>
 <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com>
 <4DDF427E.1030109@msgid.tls.msk.ru>
 <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com>
 <4DDF6917.9060004@msgid.tls.msk.ru>
 <BANLkTi==1WyJNACmoOxcrS6RiJ3w8Ow1zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi==1WyJNACmoOxcrS6RiJ3w8Ow1zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:06:37AM +0200, Paweł Drobek wrote:
> dunno, zte mf330 is pcmcia card identified itself as usb device which need to
> get working pcmcia options from kernel.

Yes, older devices put a whole USB host controller device on the PCMCIA
card in order to talk to it properly without having to change their
hardware design of the modem chip.

Crazy but true.

greg k-h
