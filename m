Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1CPKYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:24:25 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48181 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab1CPKYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:24:17 -0400
Subject: Re: musb as module broken in 2.6.38
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Felipe Balbi <balbi@ti.com>
In-Reply-To: <4D808E41.8040402@ahsoftware.de>
Date: Wed, 16 Mar 2011 12:24:10 +0200
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E19651BD-B634-4BD4-96EC-70E10CD975CD@ti.com>
References: <4D8018A9.6000800@ahsoftware.de> <20110316090327.GA2325@legolas.emea.dhcp.ti.com> <4D808729.9060608@ahsoftware.de> <20110316095541.GD2325@legolas.emea.dhcp.ti.com> <4D808E41.8040402@ahsoftware.de>
To: Alexander Holler <holler@ahsoftware.de>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mar 16, 2011, at 12:17 PM, Alexander Holler wrote:
>> static int __init omap2430_probe(struct platform_device *pdev)
> 
> Neither omap2430_init() nor omap2430_probe() will be called here.

and why is that ? It's even in sysfs already:

>>> beagle linux # ls /sys/devices/platform/ | grep musb
>>> musb-omap2430

(ps: sorry if it's mis-formatted, I'm on the go, not using my laptop)

-- 
balbi

