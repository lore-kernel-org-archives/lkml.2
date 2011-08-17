Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1HQFLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:11:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40872 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQFLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:11:18 -0400
MIME-Version: 1.0
Date: Wed, 17 Aug 2011 13:11:17 +0800
Message-ID: <CAKdQVUb7s6_1RyMDyCkBZWHdAvDy1yPY4nQarqNbSspi4uHC2w@mail.gmail.com>
Subject: xen-kernel and EDD
From: Bob Zhang <zhanglinbao@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>
Cc: Bob Zhang <2004.zhang@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now , I am using RHEL5.7's xen-kernel, I must add "edd=off" ,
otherwise ,it will print this error :
1706-Smart Array Controller EBDA Memory Corrupted  £¬INT 13h BIOS
Cannot Coninue - Sytem Halted

RHEL said that their RHEL5.7 xen-kernel must make edd off ; while
non-xen kernel doesn't need to make edd off.

why ?
for community XEN developing , is there limit regarding to
EDD(Enhanced Disk Drive)  ?

welcome your comments .thanks .
-Bob
