Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1FDJpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 05:45:33 -0400
Received: from home.kolivas.org ([59.167.196.135]:40749 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab1FDJpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 05:45:32 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: lrzip compressed tarball of all 40 linux-2.6 kernels
Date: Sat, 4 Jun 2011 19:45:25 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.39-ck1; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106041945.25922.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 2.6 linux kernel now officially finished, I'm providing an lrzip 
tarball of all 40 of the 3 point kernel releases as an lrzip tarball. This is 
a convenient way of getting all the releases in a relatively low bandwidth 
form, and previous archives of this nature have had a few downloads so I 
figured I'd complete the archive for those who want to download it and use it 
as an ad for lrzip:

163.9MB:
http://ck.kolivas.org/linux-2.6.0-2.6.39.tar.lrz

10.3GB:
linux-2.6.0-2.6.39.tar

Original file is a tarball of all 3 point linux kernel release tarballs 2.6.0 
to 2.6.39 coming to a grand total of 10.3GB

Of course this is a plug for lrzip on something it is particularly good at 
compressing.

lrzip can be obtained here:
http:://lrzip.kolivas.org

About this archive: It was compressed with lrzip version 0.606 on a quad core 
3GHz core 2 on a relatively slow external USB2 hard drive with the following 
options:

lrzip -UL 9 linux-2.6.0-2.6.39.tar
Total time: 00:56:19.88

It would have compressed a lot faster without the -L 9 option, but given this 
is the "final" archive of 2.6, I figured I'd push it a bit further. Lrzip can 
compress it even further with zpaq as an option, but it makes decompression 
much slower so I'd personally find the archive less useful.

Of course someone will ask how it compares to xz, so for completion:

xz -9 linux-2.6.0-2.6.39.tar
Total time: 2:05:32.218

11067473920 linux-2.6.0-2.6.39.tar
1535618848 linux-2.6.0-2.6.39.tar.xz 13.8%
171879382 linux-2.6.0-2.6.39.tar.lrz 1.6%

-- 
-ck
