Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1DZMos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:44:48 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:52787 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab1DZMor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:44:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABy8tk1R8BPE/2dsb2JhbAClRHiIcLspDoVoBJxh
Date: Tue, 26 Apr 2011 14:44:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jimmy Chen =?utf-8?B?KOmZs+awuOmBlCk=?= <jimmy.chen@moxa.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: add real function on MOXA V2100 watchdog
	driver
Message-ID: <20110426124444.GB17580@infomag.iguana.be>
References: <ECB3782BB8F03341905DD923270296115F6AD9@mhqms01.moxa.com> <ECB3782BB8F03341905DD923270296115F6ADB@mhqms01.moxa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ECB3782BB8F03341905DD923270296115F6ADB@mhqms01.moxa.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jimmy,

> From: Jimmy Chen <jimmy.chen@moxa.com>
> 
> Add real function for watchdog driver
> 
> Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>

My first remarks:
* This driver doesn't use /dev/watchdog.
* It doesn't follow the IOCTL API for watchdog devices
* It uses .ioctl and not an .unlocked_ioctl

Kind regards,
Wim.

