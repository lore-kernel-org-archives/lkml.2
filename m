Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0CRVrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:47:09 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48457 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330Ab0CRVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:47:08 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: users@rt2x00.serialmonkey.com
Subject: rt2500usb broken since 2.6.29
Date: Thu, 18 Mar 2010 22:46:53 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003182246.54889.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
rt2500usb is broken since kernel 2.6.29. It has been discussed before but 
never solved:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
https://bugzilla.redhat.com/show_bug.cgi?id=484888

I have Asus WL-167G and it really does not work. Scanning works, association 
too but no packets can be sent (looks like receive works because tcpdump 
shows packets from other machines). DHCP fails (No DHCPOFFERS received).

The problem is caused by this patch:

rt2x00: Implement HW encryption (rt2500usb)
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dddfb478b26e29a2b47f655ec219e743b8111015

Removing it from 2.6.29 restores the functionality.

-- 
Ondrej Zary
