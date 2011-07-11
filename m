Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab1GKONY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:13:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab1GKONX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:13:23 -0400
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 19:43:22 +0530
Message-ID: <CALDXQjNEOEGjutrPcD+O7m6V60tXHf9WR00DOaF-YDAYxQ7TGw@mail.gmail.com>
Subject: request_firmware fails in static building
From: Raja Mani <rajambsc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 Apologies If i posted in wrong place..

 I am writing small driver which does request_firmware() to get
firmware file content from user space.
 If i complete it dynamically and do insmod, then works fine. If i
build it statically and reboot my PC, i am getting  -2 from
request_firmware() which is ("no such a file or directory error")

 I am using Ubuntu 10.04 lucid...

 Do i need to keep a copy of firmware file in initramfs ? If so , how
do i do it ?
 Am i missing anything else ?

 Thanks.

--
Regards,
Rajam.



-- 
Regards,
Raja.
