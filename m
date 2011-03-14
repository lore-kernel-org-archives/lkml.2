Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1CNWaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:30:06 -0400
Received: from smtp10.mail.sp.isp-net.nl ([217.149.192.65]:51759 "EHLO
	smtp10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab1CNWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:30:05 -0400
X-Greylist: delayed 3330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Mar 2011 18:30:04 EDT
Message-ID: <4D7E89E7.3080505@xmsnet.nl>
Date: Mon, 14 Mar 2011 22:34:31 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the start of the start of 2.6.38-rc I sporadic have problems with 
mplayer. A mpeg stream sometimes gets distorted when mplayer starts. An 
example is at http://www.xs4all.nl/~bruinjm/mplayer.png . I do not know 
how to trigger the behaviour, so bissecting is not possible. Since 
yesterday however I found a way to 'repair' mplayer:

echo 3 > /proc/sys/vm/drop_caches

This repairs mplayer while it is running. My latop is runs on nfsroot, 
and the mpegstreams are payed over nfs or http. I can have two instances 
of mplayer running the same mpeg stream over nfs or http with only one 
instance distorded.

-- 
Hans

