Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2DCF7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:59:13 -0400
Received: from ar100.montanavision.com ([216.146.103.100]:41667 "EHLO
	silka.with-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2DCF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:59:12 -0400
X-Greylist: delayed 755 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2012 01:59:12 EDT
Message-ID: <4F7A8EB7.4060200@silka.with-linux.com>
Date: Mon, 02 Apr 2012 23:46:31 -0600
From: Kelly Anderson <kelly@silka.with-linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120317 Thunderbird/11.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.3.1 ath9k regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch in 3.3.1 is causing ath9k device not to show/work on bootup.
ifconfig does not show the device unless I revert this patch. With the patch
reverted the device works as expected.  This is verified on two different
machines that are both using ath9k mini-pcie wifi cards.

>>  ath9k: fix going to full-sleep on PS idle

>>     commit c1afdaff90538ef085b756454f12b29575411214 upstream.


