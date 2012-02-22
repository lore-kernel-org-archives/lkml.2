Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2BVQg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:36:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52183 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2BVQg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:36:56 -0500
Message-ID: <4F4519A3.5080709@gmail.com>
Date: Wed, 22 Feb 2012 17:36:51 +0100
From: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] Lid close causes system freeze with colour effects
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm experiencing strange bug when I close lid of my Dell Studio 1555 -
system is totally frozen (no answers form ssh, no key reaction) and
display is showing some blurring, moving, colourful rectangles (see
photos [1] [2]). Any suggestions what causes it or how to debug it
(kernel log shows nothing)?

[1] http://dl.dropbox.com/u/22768404/DSC_0011.JPG
[2] http://dl.dropbox.com/u/22768404/DSC_0012.JPG

Thanks,
Lukasz Sowa
