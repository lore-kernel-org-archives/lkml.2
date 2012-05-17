Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928Ab2EQOAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:00:54 -0400
Received: from host.mutexes.org ([96.126.122.245]:36087 "EHLO host.mutexes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761186Ab2EQOAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:00:52 -0400
X-Greylist: delayed 1817 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2012 10:00:52 EDT
To: <netfilter@vger.kernel.org>
Subject: iptable stop hung
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 17 May 2012 19:00:35 +0530
From: Unni <unni@lab.mutexes.org>
Cc: <linux-kernel@vger.kernel.org>
Message-ID: <e88f94f075d38a9b52fa903788dd3117@lab.mutexes.org>
User-Agent: Roundcube Webmail/0.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"iptable stop" got hung in the server, so I killed that process. But 
still there is a modprobe process running there, that I can't kill.

oot     13834 99.8  0.0   3884   596 ?        R    11:15 132:39 
/sbin/modprobe -q -r ipt_state ip_nat_ftp iptable_nat xt_NOTRACK 
ip_conntrack_ftp ip_conntrack_netbios_ns xt_connlimit ip_conntrack 
ipt_recent

This is what I can see in dmesg

http://pastebin.com/BxEsyByC

--Unni
