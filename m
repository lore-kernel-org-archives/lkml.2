Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2HMHLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 03:11:34 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45351 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2HMHLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 03:11:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q7D7Amv4004316, This message is released by code: ctaloc0852
Message-ID: <5028A87A.4020403@realsil.com.cn>
Date: Mon, 13 Aug 2012 15:10:50 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/2] drivers/mfd: Add realtek pcie card reader driver
References: <1344823586-2956-1-git-send-email-wei_wang@realsil.com.cn> <20120813064012.GC4559@mwanda>
In-Reply-To: <20120813064012.GC4559@mwanda>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月13日 14:40, Dan Carpenter 写道:
> Looks like bitwise OR was intended here.
Hi Dan:

Thank you. I will resend the patches.

BR,
wwang
