Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2DQPkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:40:10 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35914 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754930Ab2DQPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:40:08 -0400
Message-ID: <4F8DB90A.8050504@xenotime.net>
Date: Tue, 17 Apr 2012 11:40:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for Apr 17 (pci-sysfs.c and vga_switcheroo.c)
References: <20120417144241.0d7dc5fde56b2a37ff0dcaba@canb.auug.org.au>
In-Reply-To: <20120417144241.0d7dc5fde56b2a37ff0dcaba@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 09:42 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120416:


When CONFIG_VGA_ARB is not enabled:

drivers/built-in.o: In function `boot_vga_show':
pci-sysfs.c:(.text+0x1060f): undefined reference to `vga_default_device'


and

drivers/built-in.o: In function `boot_vga_show':
pci-sysfs.c:(.text+0x8cc2): undefined reference to `vga_default_device'
drivers/built-in.o: In function `vga_switcheroo_register_client':
(.text+0x76671): undefined reference to `vga_default_device'
drivers/built-in.o: In function `vga_switchto_stage1':
vga_switcheroo.c:(.text+0x767f4): undefined reference to `vga_set_default_device'


-- 
~Randy
