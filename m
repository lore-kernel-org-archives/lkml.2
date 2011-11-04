Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1KDGpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 02:45:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57992 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1KDGpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 02:45:14 -0400
Message-ID: <4EB389BA.9000906@cn.fujitsu.com>
Date: Fri, 04 Nov 2011 14:44:10 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEtzacSFxbxlaw==?= <bond009@o2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug rtl8168
References: <7a1fedde.71754b01.4eb382e1.1200a@o2.pl>
In-Reply-To: <7a1fedde.71754b01.4eb382e1.1200a@o2.pl>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 14:45:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 14:45:17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 02:14 PM, Krzysztof Książek wrote:

> Dear support team,
> In the kernel 3.0.8 and 3.1 there is some bug with ethernet controller RTL8111/8168B PCI,
> 
> my ls pci output:
> 07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
> 
> bug in syslog:
> r8169 0000:07:00.0: eth0: unable to load firmware patch rtl_nic/rtl8168e-3.fw (-2)
> 


You can install the firmware by yourself, and it can work well without
the firmware.

I got the firmware from Fedora15 disto, and it worked well with the firmware, too.

Thanks
