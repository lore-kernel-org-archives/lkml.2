Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2CDRGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 12:06:30 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:53872 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754558Ab2CDRG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 12:06:28 -0500
Message-ID: <4F53A11E.2020806@xenotime.net>
Date: Sun, 04 Mar 2012 09:06:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-doc@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] Documentation: Fix multiple typo in Documentation
References: <1330870571-23424-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1330870571-23424-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2012 06:16 AM, Masanari Iida wrote:

> Correct following typo within 17 files in Documentation. 
> 
> "specifing" to "specifying" in vm/unevictable-lru.txt
> "subjet" to "subject" in security/Smack.txt
> "fulfil" to "fulfill" in security/keys.txt
> "symmetic" to "symmetric" in security/keys-trusted-encrypted.txt
> "Refererence" to "Reference" in device-mapper/dm-raid.txt
> "strutures" to "structures" in device-mapper/persistent-data.txt
> "attribude" to "attribute" in kbuild/kconfig-language.txt
> "satisified" to "satisfied" in virtual/kvm/mmu.txt
> "artificically" to "artificially" in virtual/kvm/mmu.txt
> "hierarhical" to "hierarchical" in cgroups/blkio-controller.txt
> "hierarhcy" to "hierarchy" in cgroups/blkio-controller.txt
> "exising" to "existing" in cgroups/blkio-controller.txt
> "deivce" to "device" in cgroups/blkio-controller.txt
> "subjectd" to "subjected" in cgroups/blkio-contoller.txt
> "Priorty" to "Priority" in filesystem/ext4.txt
> "systme" to "system" in filesystem/ext4.txt
> "fileystem" to "filesystem" in filesystem/gfs2-uevents.txt
> "returing" to "returning" in filesystem/vfs.txt
> "practise" to "practice" in devicetree/booting-without-of.txt
> "evalutation" to "evaluation" in devicetree/bindings/arm/sirf.txt
> "adresse" to "address" in devicetree/bindings/arm/omap/omap.txt
> "shedule" to "schedule" in ABI/obsolete/sysfs-class-rfkill
> "dyanmic" to "dynamic" in ABI/stable/sysfs-module
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  Documentation/ABI/obsolete/sysfs-class-rfkill      |    2 +-
>  Documentation/ABI/stable/sysfs-module              |    2 +-
>  Documentation/cgroups/blkio-controller.txt         |   18 +++++++++---------
>  Documentation/device-mapper/dm-raid.txt            |    2 +-
>  Documentation/device-mapper/persistent-data.txt    |    2 +-
>  .../devicetree/bindings/arm/omap/omap.txt          |    2 +-
>  Documentation/devicetree/bindings/arm/sirf.txt     |    2 +-
>  Documentation/devicetree/booting-without-of.txt    |    2 +-
>  Documentation/filesystems/ext4.txt                 |    4 ++--
>  Documentation/filesystems/gfs2-uevents.txt         |    2 +-
>  Documentation/filesystems/vfs.txt                  |    2 +-
>  Documentation/kbuild/kconfig-language.txt          |    2 +-
>  Documentation/security/Smack.txt                   |    2 +-
>  Documentation/security/keys-trusted-encrypted.txt  |    2 +-
>  Documentation/security/keys.txt                    |    2 +-
>  Documentation/virtual/kvm/mmu.txt                  |    4 ++--
>  Documentation/vm/unevictable-lru.txt               |    2 +-
>  17 files changed, 27 insertions(+), 27 deletions(-)


