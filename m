Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1GCNaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:30:08 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63601 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1GCNaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:30:05 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
Date: Sun, 3 Jul 2011 15:29:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <201106292121.34523.a.miskiewicz@gmail.com>
In-Reply-To: <201106292121.34523.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107031529.58958.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 29 czerwca 2011 o 21:21:34 Arkadiusz Miskiewicz wrote:
> Hi,
> 
> Something broke between rc3 and rc5. Thinkpad t400, logitech usb mouse.
> After resume from ram usb device no longer works. Somewhere around rc3 it
> was working fine.
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=38722
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
