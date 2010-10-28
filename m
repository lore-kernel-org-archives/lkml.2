Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab0J1H2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:28:38 -0400
Received: from smtp.turknetserver.com ([193.192.122.40]:37546 "EHLO
	smtp.turknetserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab0J1H2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:28:36 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2010 03:28:35 EDT
Message-ID: <4CC923AC.4050903@turknetserver.com>
Date: Thu, 28 Oct 2010 10:18:04 +0300
From: Tarkan Erimer <tarkan@turknetserver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tar.gz and tar.bz2 files of linux kernel on ftp.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why there are two different (tar.gz and tar.bz2) kind of compressed 
linux kernel on ftp.kernel.org ?

One kind of (.tar.bz2 or .tar.xz etc.) compressed file, probably, will 
be enough for everybody. Personally, I always download the .tar.bz2 one 
because of its shorter file length compared to .tar.gz. If it's needed 
to have two different kind of compressed linux kernel because of some 
extraordinary situations, maybe we have to consider other better options 
like .tar.xz for instance. I did a quick comparison between .tar.bz2 and 
tar.xz compressed linux-2.6.36. Here is what I found :

linux-a9un:/home/tarkane/Downloads # ls -alh linux-2.6.36.tar.*
-rw-r--r-- 1 root root 68M Oct 21 09:14 linux-2.6.36.tar.bz2
-rw-r--r-- 1 root root 59M Oct 28 09:54 linux-2.6.36.tar.xz
linux-a9un:/home/tarkane/Downloads #

As seen above, .tar.xz has better ratio (%13.24 smaller sized file than 
.tar.bz2.) than the .tar.bz2 one. So,if it could be an, at least, an 
option to offer .tar.xz compressed kernel, we could have the following 
benefits :

- Better usage of ftp.kernel.org's and downloaders' (Some people use 
bandwidth limited Internet connections.) internet bandwidth.
- Better disk space usage on ftp.kernel.org servers due to more smaller 
file sizes.
- It will reduce the load on ftp.kernel.org servers due to shorter 
download times.

I will be happy to hear your opinions about it. :-)

Tarkan
