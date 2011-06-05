Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1FEFa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 01:30:59 -0400
Received: from home.kolivas.org ([59.167.196.135]:41293 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1FEFa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 01:30:59 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: lrzip compressed tarball of all 161 stable linux kernels
Date: Sun, 5 Jun 2011 15:30:52 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.39-ck1; KDE/4.6.2; x86_64; ; )
References: <201106041945.25922.kernel@kolivas.org>
In-Reply-To: <201106041945.25922.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106051530.52053.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jun 2011 19:45:25 Con Kolivas wrote:
> With the 2.6 linux kernel now officially finished, I'm providing an lrzip
> tarball of all 40 of the 3 point kernel releases as an lrzip tarball. This
> is a convenient way of getting all the releases in a relatively low
> bandwidth form, and previous archives of this nature have had a few
> downloads so I figured I'd complete the archive for those who want to
> download it and use it as an ad for lrzip:
> 
> 163.9MB:
> http://ck.kolivas.org/linux-2.6.0-2.6.39.tar.lrz
> 
> 10.3GB:
> linux-2.6.0-2.6.39.tar
> 
> Original file is a tarball of all 3 point linux kernel release tarballs
> 2.6.0 to 2.6.39 coming to a grand total of 10.3GB
> 
> Of course this is a plug for lrzip on something it is particularly good at
> compressing.
> 
> lrzip can be obtained here:
> http:://lrzip.kolivas.org
> 
> About this archive: It was compressed with lrzip version 0.606 on a quad
> core 3GHz core 2 on a relatively slow external USB2 hard drive with the
> following options:
> 
> lrzip -UL 9 linux-2.6.0-2.6.39.tar
> Total time: 00:56:19.88
> 
> It would have compressed a lot faster without the -L 9 option, but given
> this is the "final" archive of 2.6, I figured I'd push it a bit further.
> Lrzip can compress it even further with zpaq as an option, but it makes
> decompression much slower so I'd personally find the archive less useful.
> 
> Of course someone will ask how it compares to xz, so for completion:
> 
> xz -9 linux-2.6.0-2.6.39.tar
> Total time: 2:05:32.218
> 
> 11067473920 linux-2.6.0-2.6.39.tar
> 1535618848 linux-2.6.0-2.6.39.tar.xz 13.8%
> 171879382 linux-2.6.0-2.6.39.tar.lrz 1.6%

I figured I'd do the rest as well.

Here is a tarball of all 161 stable 3 point releases from linux-1.0 to 
linux-2.6.39:

211MB:
http://ck.kolivas.org/linux-1.0-2.6.39.tar.lrz

19617064960 linux-1.0-2.6.39.tar
221368298 linux-1.0-2.6.39.tar.lrz 1.1%

As compressing this workload is mostly I/O bound I performed it on an SSD 
drive this time:

linux-1.0-2.6.39.tar - Compression Ratio: 88.617. Average Compression Speed:  
8.026MB/s.
Total time: 00:38:50.76

-- 
-ck
