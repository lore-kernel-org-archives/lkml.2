Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab2EIQUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:20:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42884 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2EIQUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:20:05 -0400
MIME-Version: 1.0
Date: Wed, 9 May 2012 18:20:03 +0200
Message-ID: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
Subject: Big I/O latencies, except when iotop is hooked
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been noticing big I/O latencies when doing operations with
notmuch (xapian database), the operations are quite simple and
probably should not need a lot of I/O, however, they seen to take a
long time, sometimes even seconds. But when I hook iotop (-p pid), the
latency goes away, and every operation is reliably instantaneous
(basically).

Do you have any ideas what might be causing this delay, and why is
iotop making it go away?

BTW. This is an ext4 encrypted partition on a USB stick, I tried
different mount options without any noticeable change. I tried to copy
the data to my SSD drive and do the same operations, while it was much
faster, it still seemed to have some delays triggered randomly. This
is with v3.3.5.

Cheers.

-- 
Felipe Contreras
