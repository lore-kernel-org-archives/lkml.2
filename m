Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LSTLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:11:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LSTLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:11:40 -0500
Date: Mon, 19 Dec 2011 14:11:28 -0500 (EST)
Message-Id: <20111219.141128.1563372305361818137.davem@davemloft.net>
To: igor@egorkin.ru
Cc: linux-kernel@vger.kernel.org, allan@asix.com.tw, grundler@chromium.org
Subject: Re: drivers/net/usb/asix: strange numeration of eth interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324280623.19383.8.camel@igor-pc.lan>
References: <1324280623.19383.8.camel@igor-pc.lan>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Dec 2011 11:11:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What you're seeing isn't strange, it depends upon what ethernet devices were
visible when you installed your machine.

'udev' in userspace remembers the mappings from ethernet addresses to
device names, and renames devices as the system comes up to what it
first saw them as, based upon the MAC address.

So one possibility is that there were 2 other ethernet or wireless devices
in your system at install time, so the one that the ASIX device got was
'eth2'.

Therefore that is the device name it will have until you tell 'udev' to
do otherwise.
