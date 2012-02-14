Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2BNW1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:27:33 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:33358 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab2BNW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:27:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120214.144622.678577766818888054.davem@davemloft.net>
References: <1329230375-25508-1-git-send-email-toby.gray@realvnc.com>
	<20120214.144622.678577766818888054.davem@davemloft.net>
Date: Tue, 14 Feb 2012 23:27:29 +0100
Message-ID: <CAL_Kpj0VSu-ByUEwTeVG5-5psab3h38bTL=ot7vYD8A+Oeb_Ug@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: cdc-ncm: Increase maximum allowed datagram size
From: Alexey Orishko <alexey.orishko@gmail.com>
To: David Miller <davem@davemloft.net>, toby.gray@realvnc.com
Cc: oliver@neukum.name, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 8:46 PM, David Miller <davem@davemloft.net> wrote:
>
> Can a USB expert please sanity check this before I apply it?

I would recommend to change CDC_NCM_NTB_MAX_SIZE_TX(RX) to 32K and
simply set MAX_DATAGRAM_SIZE to 16K

/alexey
