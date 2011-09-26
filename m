Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1IZJDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:03:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58909 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1IZJDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:03:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAD+V5YLEStps68UK2NXLNh4ktGnv==WxXxWjjVJsRhk-XUp+Jw@mail.gmail.com>
References: <1316845316-5765-1-git-send-email-keguang.zhang@gmail.com>
	<1316845316-5765-2-git-send-email-keguang.zhang@gmail.com>
	<CAD+V5YLEStps68UK2NXLNh4ktGnv==WxXxWjjVJsRhk-XUp+Jw@mail.gmail.com>
Date: Mon, 26 Sep 2011 17:03:01 +0800
Message-ID: <CAJhJPsWZZ2H84pqJ-qguANP_4uYm_zF7OROwkCE2_+4Vcrha4g@mail.gmail.com>
Subject: Re: [PATCH 2/2] MIPS: Add defconfig for Loongson1B (UPDATED)
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, r0bertz@gentoo.org, chenj@lemote.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/25, wu zhangjin <wuzhangjin@gmail.com>:
> On Sat, Sep 24, 2011 at 2:21 PM,  <keguang.zhang@gmail.com> wrote:
>> From: Kelvin Cheung <keguang.zhang@gmail.com>
>>
>> This patch adds defconfig for Loongson1B.
>>
>> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
>> ---
>>  arch/mips/configs/ls1b_defconfig |   95
>> ++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 95 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/mips/configs/ls1b_defconfig
>>
>> diff --git a/arch/mips/configs/ls1b_defconfig
>> b/arch/mips/configs/ls1b_defconfig
>> new file mode 100644
>> index 0000000..f7c48f5
>> --- /dev/null
>> +++ b/arch/mips/configs/ls1b_defconfig
>> @@ -0,0 +1,95 @@
>> +CONFIG_MACH_LOONGSON1=y
>> +CONFIG_HIGH_RES_TIMERS=y
>> +CONFIG_PREEMPT_VOLUNTARY=y
>
> What is the target market of 1B?
>
> Seems CONFIG_PREEMPT_VOLUNTARY is for Desktop, CONFIG_PREEMPT is
> better for low-latency desktop
> and even for some real time applications.

Replaced with CONFIG_PREEMPT.

>> +CONFIG_KEXEC=y
>
> Did you validate kexec support on your 1B board?
>
> According to my previous experiment, The kexec support of 32bit
> Loongson2F requires more patches,
> those patches are available in the following git repo:
>
> http://dev.lemote.com/cgit/linux-loongson-community.git/log/?h=tiny36
>
> or
>
> git://dev.lemote.com/linux-loongson-community.git tiny36
>
>> +# CONFIG_SECCOMP is not set
>> +CONFIG_EXPERIMENTAL=y
>> +# CONFIG_LOCALVERSION_AUTO is not set
>> +CONFIG_SYSVIPC=y
>> +CONFIG_BSD_PROCESS_ACCT=y
>> +CONFIG_BSD_PROCESS_ACCT_V3=y
>> +CONFIG_IKCONFIG=y
>> +CONFIG_IKCONFIG_PROC=y
>> +CONFIG_LOG_BUF_SHIFT=16
>> +CONFIG_BLK_DEV_INITRD=y
>> +CONFIG_RD_BZIP2=y
>> +CONFIG_RD_LZMA=y
>> +CONFIG_RD_XZ=y
>> +CONFIG_RD_LZO=y
>
> Not sure why you need all of these 4 compression algorithms, LZO is
> the fastest one, LZMA has the largest compression ratio.
>
>> +CONFIG_EXPERT=y
>> +CONFIG_KALLSYMS_ALL=y
>> +CONFIG_PERF_EVENTS=y
>> +# CONFIG_COMPAT_BRK is not set
>> +CONFIG_MODULES=y
>> +CONFIG_MODULE_UNLOAD=y
>> +CONFIG_MODVERSIONS=y
>> +# CONFIG_LBDAF is not set
>> +# CONFIG_BLK_DEV_BSG is not set
>> +# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
>> +# CONFIG_SUSPEND is not set
>> +CONFIG_NET=y
>> +CONFIG_PACKET=y
>> +CONFIG_UNIX=y
>> +CONFIG_INET=y
>> +CONFIG_IP_PNP=y
>> +CONFIG_IP_PNP_DHCP=y
>> +CONFIG_SYN_COOKIES=y
>> +# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
>> +# CONFIG_INET_XFRM_MODE_TUNNEL is not set
>> +# CONFIG_INET_XFRM_MODE_BEET is not set
>> +# CONFIG_INET_DIAG is not set
>> +# CONFIG_IPV6 is not set
>> +# CONFIG_WIRELESS is not set
>> +CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>> +CONFIG_DEVTMPFS=y
>> +CONFIG_DEVTMPFS_MOUNT=y
>> +# CONFIG_STANDALONE is not set
>> +CONFIG_BLK_DEV_LOOP=y
>> +# CONFIG_INPUT_MOUSEDEV is not set
>> +# CONFIG_INPUT_KEYBOARD is not set
>> +# CONFIG_INPUT_MOUSE is not set
>> +# CONFIG_SERIO is not set
>> +CONFIG_VT_HW_CONSOLE_BINDING=y
>> +CONFIG_LEGACY_PTY_COUNT=8
>> +# CONFIG_DEVKMEM is not set
>> +CONFIG_SERIAL_8250=y
>> +CONFIG_SERIAL_8250_CONSOLE=y
>> +CONFIG_SERIAL_8250_RUNTIME_UARTS=1
>> +# CONFIG_HW_RANDOM is not set
>> +CONFIG_RAMOOPS=y
>> +# CONFIG_HWMON is not set
>> +# CONFIG_MFD_SUPPORT is not set
>> +# CONFIG_VGA_CONSOLE is not set
>> +# CONFIG_HID_SUPPORT is not set
>> +# CONFIG_USB_SUPPORT is not set
>> +# CONFIG_IOMMU_SUPPORT is not set
>> +CONFIG_EXT2_FS=y
>> +CONFIG_EXT2_FS_XATTR=y
>> +CONFIG_EXT2_FS_POSIX_ACL=y
>> +CONFIG_EXT2_FS_SECURITY=y
>> +CONFIG_EXT3_FS=y
>> +CONFIG_EXT3_FS_POSIX_ACL=y
>> +CONFIG_EXT3_FS_SECURITY=y
>
> Seems we have EXT4 now, but PMON may not support it currently ;)
>
>> +# CONFIG_DNOTIFY is not set
>> +CONFIG_PROC_KCORE=y
>> +CONFIG_TMPFS=y
>> +CONFIG_TMPFS_POSIX_ACL=y
>> +# CONFIG_MISC_FILESYSTEMS is not set
>> +# CONFIG_NETWORK_FILESYSTEMS is not set
>> +# CONFIG_ENABLE_WARN_DEPRECATED is not set
>> +# CONFIG_ENABLE_MUST_CHECK is not set
>> +CONFIG_UNUSED_SYMBOLS=y
>> +CONFIG_DEBUG_FS=y
>> +CONFIG_DETECT_HUNG_TASK=y
>> +CONFIG_SCHEDSTATS=y
>> +CONFIG_TIMER_STATS=y
>> +CONFIG_DEBUG_INFO=y
>> +CONFIG_DEBUG_MEMORY_INIT=y
>> +CONFIG_BOOT_PRINTK_DELAY=y
>> +CONFIG_SYSCTL_SYSCALL_CHECK=y
>> +# CONFIG_FTRACE is not set
>> +CONFIG_KGDB=y
>> +CONFIG_KGDB_LOW_LEVEL_TRAP=y
>> +CONFIG_KGDB_KDB=y
>
> If this config is for product, the above debug support may be not required.
>
> Best Regards,
> Wu Zhangjin
>
>> +CONFIG_KDB_KEYBOARD=y
>> +# CONFIG_EARLY_PRINTK is not set
>> --
>> 1.7.4.1
>>
>>
>


-- 
Best Regards!
Kelvin
