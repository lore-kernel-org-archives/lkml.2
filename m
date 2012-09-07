Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab2IGWpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:45:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61814 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2IGWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:45:03 -0400
Message-ID: <504A78E9.4030005@lwfinger.net>
Date: Fri, 07 Sep 2012 17:44:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Subject: Question about failure in PCI power-state change
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On occasion when I unload and reload driver rtl8192ce, I get the message

"Refused to change power state, currently in D3"

I added additional info to the printk and discovered that it was trying to 
change to state D0. The problem seems to occur when I have made a connection, 
unloaded the driver, and reloaded it. If I do not make a connection before 
unloading, then the problem is a lot less likely.

This is with kernel 3.6-rc4 from wireless-testing. A Google search shows that 
the problem is usually due to suspend/resume difficulties, but this machine has 
not been suspended.

I would appreciate any help that you might give in solving this issue.

Thanks,

Larry
