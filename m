Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1JaUij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:38:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1JaUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:38:38 -0400
MIME-Version: 1.0
Date: Mon, 31 Oct 2011 21:38:37 +0100
Message-ID: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com>
Subject: =?windows-1252?Q?ext4_bug_=3F_=22Intel_320_SSD_write_performance_=96_cont?=
	=?windows-1252?Q?d=2E=22?=
From: Vincent Pelletier <plr.vincent@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Reading this blog post[1], I thought the "2nd iteration" results could be
considered a bug in mkfs.ext4 (and possibly any mkfs implementation):
shouldn't mkfs run [FI]TRIM on its target before creating filesystem
structure ?

Disclaimers:
I don't know much about mkfs nor in-kernel fs support to tell which part
should implement this - so I cannot even tell for sure this isn't done
already.
I have no idea how expensive those new calls would be (in general, this
means trimming a _lot_ of pages...).
I don't know how other filesystems/os behave on such bench. But I
don't think this is a problem any SSD could solve at its level.

[1] http://www.mysqlperformanceblog.com/2011/09/28/intel-320-ssd-write-performance-contd/

Regards,
-- 
Vincent Pelletier
