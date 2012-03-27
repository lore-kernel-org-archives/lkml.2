Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2C0KUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:20:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36312 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab2C0KUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:20:00 -0400
MIME-Version: 1.0
From: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
Date: Tue, 27 Mar 2012 18:19:39 +0800
Message-ID: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
Subject: Small and unimportant description mistakes of Kernel compression mode
 in kernel config
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the mistake is enclosed by brackets[]

In bzip2 the description is:
Its compression ratio and speed is intermediate.
Decompression speed is slowest among the [three]. The kernel
size is about 10% smaller with bzip2, in comparison to gzip.
Bzip2 uses a large amount of memory. For modern kernels you
will need at least 8MB RAM or more for booting.

In lzma the description is:
The most recent compression algorithm.
Its ratio is best, decompression speed is [between the other
two]. Compression is slowest. The kernel size is about 33%
smaller with LZMA in comparison to gzip.

The LZO's description is:
Its compression ratio is the poorest among the [4]. The kernel
size is about 10% bigger than gzip; however its speed
(both compression and decompression) is the fastest.

But there are five compression algorithms in total :)
