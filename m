Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab0EMT1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:27:55 -0400
Received: from xenotime.net ([72.52.115.56]:35295 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757383Ab0EMT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:27:53 -0400
Message-ID: <4BEC52C0.1000403@xenotime.net>
Date: Thu, 13 May 2010 12:28:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
References: <4BEC4B0D.8010102@example.com> <4BEC4CD6.6090402@example.com>
In-Reply-To: <4BEC4CD6.6090402@example.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piotr Hosowicz wrote:
> On 13.05.2010 20:55, Piotr Hosowicz wrote:
> 
>> I could find the option in menuconfig and I don't want to edit .config
>> by hand, because there are various *SYSFS* options there.
> 
> Sorry, I mistyped, I meant I _cannot_ find it in menuconfig nor in .config.

The only thing about  SYSFS that is deprecated AFAIK is in init/Kconfig:

config SYSFS_DEPRECATED_V2
	bool "enable deprecated sysfs features to support old userspace tools"
	depends on SYSFS
	default n
	select SYSFS_DEPRECATED
	help
	  This option switches the layout of sysfs to the deprecated
	  version. Do not use it on recent distributions.

HTH.


