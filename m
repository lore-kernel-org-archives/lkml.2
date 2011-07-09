Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1GIMJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 08:09:18 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53123 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1GIMJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 08:09:17 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Sven-Haegar Koch" <haegar@sdinet.de>
Subject: Re: 3.0-rc+git OOPS losetup on cifs
Date: Sat, 9 Jul 2011 14:09:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        "Linux-Kernel-Mailinglist" <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.02.1107042132500.18300@aurora>
In-Reply-To: <alpine.DEB.2.02.1107042132500.18300@aurora>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107091409.12789.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 4 lipca 2011 o 21:48:50 Sven-Haegar Koch wrote:
> hello,
> 
> Since a short while (I know it worked with 3.0-rc1) loopback-mounting an
> image on a samba server mounted with cifs oopses the kernel.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=39042
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
