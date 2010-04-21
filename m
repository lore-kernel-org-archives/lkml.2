Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0DUGIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 02:08:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25173 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0DUGI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 02:08:27 -0400
Message-ID: <4BCE95D1.6070105@oracle.com>
Date: Tue, 20 Apr 2010 23:06:09 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Henriksson <peter.henriksson@gmail.com>
CC: Yinghai <yinghai.lu@oracle.com>, Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
 977d17bb174
References: <4BCBFE89.9070401@ladisch.de>	 <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>	 <4BCC0F10.3070208@ladisch.de>	 <l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>	 <4BCCA5FD.6060002@oracle.com> <1271706161.2505.6.camel@darwin.lan>	 <4BCD4C8D.7070805@oracle.com>	 <n2yf046f1351004200103zdcf703e6ofea41dc688a5e62e@mail.gmail.com>	 <r2o86802c441004201022i32f328e2n7a125df88f67e390@mail.gmail.com> <1271789155.2554.2.camel@darwin.lan>
In-Reply-To: <1271789155.2554.2.camel@darwin.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4BCE9653.0138:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 11:45 AM, Peter Henriksson wrote:
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: scanning [bus 04-09] behind
> bridge, pass 0
> Apr 20 20:31:42 [kernel] pci_bus 0000:04: scanning bus
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: found [10b5:8518] class
> 000604 header type 01
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: reg 10: [mem
> 0xfeae0000-0xfeafffff]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: calling
> quirk_resource_alignment+0x0/0x166
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PME# supported from D0 D3hot
> D3cold
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PME# disabled
> Apr 20 20:31:42 [kernel] pci_bus 0000:04: fixups for bus
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
> 0xfea00000-0xfeafffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
> 0xf8e00000-0xf8ffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: scanning [bus 05-09] behind
> bridge, pass 0
> Apr 20 20:31:42 [kernel] pci_bus 0000:05: scanning bus
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: found [10b5:8518] class
> 000604 header type 01
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: calling
> quirk_resource_alignment+0x0/0x166
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PME# supported from D0 D3hot
> D3cold
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PME# disabled
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: found [10b5:8518] class
> 000604 header type 01
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: calling
> quirk_resource_alignment+0x0/0x166
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PME# supported from D0 D3hot
> D3cold
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PME# disabled
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: found [10b5:8518] class
> 000604 header type 01
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: calling
> quirk_resource_alignment+0x0/0x166
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PME# supported from D0 D3hot
> D3cold
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PME# disabled
> Apr 20 20:31:42 [kernel] pci_bus 0000:05: fixups for bus
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
> 0xfff00000-0x000fffff] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
> 0xf8e00000-0xf8ffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: scanning [bus 08-09] behind
> bridge, pass 0
> Apr 20 20:31:42 [kernel] pci_bus 0000:08: scanning bus
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: found [10b5:8112] class
> 000604 header type 01
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: calling
> quirk_resource_alignment+0x0/0x166
> Apr 20 20:31:42 [kernel] pci_bus 0000:08: fixups for bus
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
> 0xfff00000-0x000fffff] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
> 0xfff00000-0x000fffff pref] (disabled)
> Apr 20 20:31:42 [kernel] pci_bus 0000:09: scanning bus
> Apr 20 20:31:42 [kernel] pci 0000:09:04.0: found [13f6:8788] class
> 000401 header type 00
> Apr 20 20:31:42 [kernel] pci 0000:09:04.0: reg 10: [io  0xd800-0xd8ff]
> Apr 20 20:31:42 [kernel] pci 0000:09:04.0: calling
> quirk_resource_alignment+0x0/0x166
> Apr 20 20:31:42 [kernel] pci 0000:09:04.0: supports D1 D2
> Apr 20 20:31:42 [kernel] pci_bus 0000:09: fixups for bus
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
> 0xfff00000-0x000fffff] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
> 0xfff00000-0x000fffff pref] (disabled)
> Apr 20 20:31:42 [kernel] pci_bus 0000:09: bus scan returning with max=09
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: scanning [bus 09-09] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci_bus 0000:08: bus scan returning with max=09
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: scanning [bus 07-07] behind
> bridge, pass 0
> Apr 20 20:31:42 [kernel] pci_bus 0000:07: scanning bus
> Apr 20 20:31:42 [kernel] pci_bus 0000:07: fixups for bus
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [io
> 0xf000-0x0000] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
> 0xfff00000-0x000fffff] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
> 0xf8f00000-0xf8ffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci_bus 0000:07: bus scan returning with max=07
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: scanning [bus 06-06] behind
> bridge, pass 0
> Apr 20 20:31:42 [kernel] pci_bus 0000:06: scanning bus
> Apr 20 20:31:42 [kernel] pci_bus 0000:06: fixups for bus
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [io
> 0xf000-0x0000] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
> 0xfff00000-0x000fffff] (disabled)
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
> 0xf8e00000-0xf8efffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci_bus 0000:06: bus scan returning with max=06
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: scanning [bus 08-09] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: scanning [bus 07-07] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: scanning [bus 06-06] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci_bus 0000:05: bus scan returning with max=09
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: scanning [bus 05-09] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci_bus 0000:04: bus scan returning with max=09

> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: scanning [bus 04-09] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: scanning [bus 03-03] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: scanning [bus 02-02] behind
> bridge, pass 1
> Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: scanning [bus 0a-0a] behind
> bridge, pass 1
...
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 0: reserving [mem
> 0xfeae0000-0xfeafffff flags 0x40200] (d=0, p=0)
> Apr 20 20:31:42 [kernel] pci 0000:09:04.0: BAR 0: reserving [io
> 0xd800-0xd8ff flags 0x40101] (d=0, p=0)
...
> Apr 20 20:31:42 [kernel] PCI: max bus depth: 4 pci_try_num: 5
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: can't assign mem (size
> 0xc00000)
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: can't assign mem (size
> 0x200000)
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: can't assign mem pref
> (size 0x200000)
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: can't assign mem (size
> 0x400000)
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
> 0x1000)
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [mem pref
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [mem pref
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [io
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem
> 0xf8f00000-0xf8ffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [io
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem
> 0xf8e00000-0xf8efffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem
> 0xf8e00000-0xf8ffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [io
> 0xd000-0xdfff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
> 0xfea00000-0xfeafffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
> 0xf8e00000-0xf8ffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [io
> 0xc000-0xcfff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
> 0xfe900000-0xfe9fffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.4:   bridge window [mem
> 0x80000000-0x801fffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [io
> 0xb000-0xbfff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
> 0xfe800000-0xfe8fffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.5:   bridge window [mem
> 0x80200000-0x803fffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
> Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [io
> 0xe000-0xefff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem
> 0xfeb00000-0xfebfffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1e.0:   bridge window [mem pref
> disabled]
> Apr 20 20:31:42 [kernel] PCI: No. 2 try to assign unassigned res
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [io
> 0xa000-0xafff]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
> 0xfa000000-0xfe7fffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: can't assign mem (size
> 0xc00000)
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: can't assign mem (size
> 0x200000)
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: can't assign mem pref
> (size 0x200000)
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: can't assign mem (size
> 0x400000)
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 8: can't assign mem (size
> 0x400000)
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 7: can't assign io (size
> 0x1000)
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
> 0x1000)

several devices PCI bar doesn't get assigned from BIOS.

> Apr 20 20:31:42 [kernel] PCI: No. 3 try to assign unassigned res
> Apr 20 20:31:42 [kernel] release child resource [io  0xd800-0xd8ff]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: resource 7 [io
> 0xd000-0xdfff] released
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: PCI bridge to [bus 09-09]
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0:   bridge window [io
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: resource 7 [io
> 0xd000-0xdfff] released
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: PCI bridge to [bus 08-09]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0:   bridge window [io
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: resource 7 [io
> 0xd000-0xdfff] released
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [io
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: resource 9 [mem
> 0xf8f00000-0xf8ffffff 64bit pref] released
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: PCI bridge to [bus 07-07]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0:   bridge window [mem pref
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: resource 9 [mem
> 0xf8e00000-0xf8efffff 64bit pref] released
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: PCI bridge to [bus 06-06]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0:   bridge window [mem pref
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: resource 9 [mem
> 0xf8e00000-0xf8ffffff 64bit pref] released
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: PCI bridge to [bus 05-09]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0:   bridge window [mem pref
> disabled]
> Apr 20 20:31:42 [kernel] release child resource [mem
> 0xfeae0000-0xfeafffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: resource 8 [mem
> 0xfea00000-0xfeafffff] released
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: PCI bridge to [bus 04-09]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0:   bridge window [mem
> disabled]
> Apr 20 20:31:42 [kernel] pci 0000:00:1c.0: BAR 8: assigned [mem
> 0x80400000-0x816fffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [io
> 0xa000-0xafff]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
> 0xfa000000-0xfe7fffff]
> Apr 20 20:31:42 [kernel] pci 0000:00:01.0:   bridge window [mem
> 0xd0000000-0xdfffffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 8: assigned [mem
> 0x80400000-0x80ffffff]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 9: assigned [mem
> 0x81000000-0x815fffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 0: assigned [mem
> 0x81600000-0x8161ffff]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 0: set to [mem
> 0x81600000-0x8161ffff] (PCI address [0x81600000-0x8161ffff]
> Apr 20 20:31:42 [kernel] pci 0000:04:00.0: BAR 7: can't assign io (size
> 0x4000)
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 8: assigned [mem
> 0x80400000-0x805fffff]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 9: assigned [mem
> 0x81000000-0x811fffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 8: assigned [mem
> 0x80600000-0x809fffff]
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 9: assigned [mem
> 0x81200000-0x813fffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 8: assigned [mem
> 0x80a00000-0x80dfffff]
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 9: assigned [mem
> 0x81400000-0x815fffff 64bit pref]
> Apr 20 20:31:42 [kernel] pci 0000:05:01.0: BAR 7: can't assign io (size
> 0x2000)
> Apr 20 20:31:42 [kernel] pci 0000:05:02.0: BAR 7: can't assign io (size
> 0x1000)
> Apr 20 20:31:42 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size
> 0x1000)
> Apr 20 20:31:42 [kernel] pci 0000:08:00.0: BAR 7: can't assign io (size
> 0x1000)
> Apr 20 20:31:42 [kernel] pci 0000:09:04.0: BAR 0: can't assign io (size
> 0x100)

after several times retry, mmio ranges get assigned, but io port range can be allocated enough range. it needs 16k,
but under 05:01.0 to 08:00.0 and 09:04.0 orginal io port from BIOS allocation get lost.

wonder be good, if We can restore it for such case.

current may have to disable bridge resizing feature by default.

can you send out 
lspci -vvxxx
lspci -tv 

YH
