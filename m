Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2LUXMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:12:32 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:58682 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2LUXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:12:31 -0500
X-Greylist: delayed 1023 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 18:12:30 EST
MIME-Version: 1.0
From: Subbaramaiah Mandava <subbulikes@gmail.com>
Date: Fri, 21 Dec 2012 14:49:30 -0800
Message-ID: <CADFrfx1Bw3Zduae9X4eA2E4piuOPtO9tDpUrLs=9WXqwZE5oew@mail.gmail.com>
Subject: /proc/meminfo descrepancy?
To: kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
Cc: adobriyan@gmail.com, hugh.dickins@tiscali.co.uk, dhowells@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a arm board running android and I see there is a
small doubt which I have got.
I don't doubt the code written but I doubt my understanding
of below:

In the bootup logs low mem is
lowmem  : 0xc0000000 - 0xe6000000   ( 608 MB)

but when I check the cat /proc/meminfo
it shows LowTotal:         512328 kB

Why is there discrepancy in the numbers?Should it not be same?
