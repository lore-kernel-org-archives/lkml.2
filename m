Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2D0Bxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 21:53:49 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40033 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab2D0Bxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 21:53:48 -0400
Message-ID: <4F99FC28.80504@gmail.com>
Date: Thu, 26 Apr 2012 21:53:44 -0400
From: Joe Ceklosky <jfceklosky@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120315 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possible 32-bit PAE kernel I/O slow down with 3.3.X
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have notice significant slow downs with disk I/O on a 32-bit PAE 3.3.X 
kernels.

The test machine has 16GB memory, Intel i5 CPU, Intel
motherboard, and an Intel 160GB SSD.  I copied 536M from one partition 
on an SSD to another.
Yes, I should be using a 64bit kernel with 16GB!

Test 1:
kernel 3.3.2 32-bit PAE with kernel parm mem=3G

time cp -ra testdir/ /tmp
real    0m8.989s
user    0m0.094s
sys     0m1.080s

Test 2:
kernel 3.3.2 32-bit PAE

time cp -ra testdir/ /tmp
real    1m17.068s
user    0m0.173s
sys     0m2.149s


Also I tested kernel 3.2.16 32-bit PAE with no memory limits 16GB and it
was in line with test 1.

I can repeat and provide any debugging information if needed.



Thanks,
Joe Ceklosky
