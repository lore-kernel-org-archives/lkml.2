Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab1LFD7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:59:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab1LFD7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:59:42 -0500
Date: Tue, 6 Dec 2011 11:58:52 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de, amworsley@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:usb:serial:ftdi_sio.c: ftdi_set_termios make no
 sense some in a situation
Message-ID: <20111206035852.GA17764@udknight.homenetwork>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
	amworsley@gmail.com, linux-kernel@vger.kernel.org
References: <20111205074730.GA10142@udknight.homenetwork>
 <20111205113424.6225ddcb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205113424.6225ddcb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:34:24AM +0000, Alan Cox wrote:
> NACK
> 
> Think about what happens if you have two such ports or remove and re-add
> it.
> 
Alan, you are right! Thanks
> What code path is calling set_termios passing a termios data which has
> never been set ?
> 
> Alan

The question I meet is my usb-convertor base on FT232RL doesn't work, but it 
works well if I revert b1ffb4c851f185e9051ba837c16d9b84ef688d26.It seems that
I should dig deeper.
