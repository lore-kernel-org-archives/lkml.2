Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1APUYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 15:24:09 -0500
Received: from webmail10.mail.sp.isp-net.nl ([217.149.192.62]:56061 "EHLO
	webmail10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403Ab1APUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 15:24:05 -0500
Message-ID: <4D335417.80704@xmsnet.nl>
Date: Sun, 16 Jan 2011 21:24:55 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Possible ipv6 regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After last nights compile i lost the possibility to connect to ssh and 
http over ipv6. The connection stops at syn_sent. connections to my 
machine end in syn_recv. ping6 still works.

-- 
Hans
