Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1BLGng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 01:43:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34881 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1BLGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 01:43:29 -0500
Date: Fri, 11 Feb 2011 22:42:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 11 (build errors/warnings)
Message-Id: <20110211224226.f1fb1ef9.randy.dunlap@oracle.com>
In-Reply-To: <20110211164713.51c102c5.sfr@canb.auug.org.au>
References: <20110211164713.51c102c5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D562C09.00EE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 16:47:13 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110210:

(no time for patches today)


drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2315: error: too few arguments to function 'ieee80211_channel_to_frequency'

sound/pci/asihpi/hpi6205.c:2090: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'

sound/pci/asihpi/hpi6205.c:2090: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'

drivers/staging/wlan-ng/prism2fw.c:1116: warning: the frame size of 4304 bytes is larger than 2048 bytes
drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from incompatible pointer type

drivers/tty/n_gsm.c:535: warning: zero-length gnu_printf format string


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
