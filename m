Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab1HYOIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:08:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34683 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1HYOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com>
References: <20110722154219.GA25694@elte.hu>
	<CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
	<CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com>
Date: Thu, 25 Aug 2011 10:06:52 -0400
Message-ID: <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd2db7cd452f604ab54f03c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2db7cd452f604ab54f03c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 25, 2011 at 7:51 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, Aug 25, 2011 at 1:58 AM, Arnaud Lacombe <lacombar@gmail.com> wrot=
e:
>> Hi,
>>
>> On Fri, Jul 22, 2011 at 11:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>> Linus,
>>>
>>> Please pull the latest x86-vdso-for-linus git tree from:
>>>
>>> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git=
 x86-vdso-for-linus
>>>
>>>
>>> out-of-topic modifications in x86-vdso-for-linus:
>>> -------------------------------------------------
>>> arch/ia64/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0# ae7bd11: clockso=
urce: Change __ARCH_HAS_CL
>>> arch/ia64/include/asm/clocksource.h# ae7bd11: clocksource: Change __ARC=
H_HAS_CL
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 # 5=
74c44f: ia64: Replace clocksource.fsys_mm
>>> arch/ia64/kernel/cyclone.c =A0 =A0 =A0 =A0 # 574c44f: ia64: Replace clo=
cksource.fsys_mm
>>> arch/ia64/kernel/time.c =A0 =A0 =A0 =A0 =A0 =A0# 574c44f: ia64: Replace=
 clocksource.fsys_mm
>>> arch/ia64/sn/kernel/sn2/timer.c =A0 =A0# 574c44f: ia64: Replace clockso=
urce.fsys_mm
>>> drivers/char/hpet.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0# 574c44f: ia64: Rep=
lace clocksource.fsys_mm
>>> include/linux/clocksource.h =A0 =A0 =A0 =A0# ae7bd11: clocksource: Chan=
ge __ARCH_HAS_CL
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 # 5=
74c44f: ia64: Replace clocksource.fsys_mm
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 # 4=
33bd80: clocksource: Replace vread with g
>>> include/linux/seccomp.h =A0 =A0 =A0 =A0 =A0 =A0# 5cec93c: x86-64: Emula=
te legacy vsyscalls
>>>
>>> =A0Thanks,
>>>
>>> =A0 =A0 =A0 =A0Ingo
>>>
>>> ------------------>
>>> Andy Lutomirski (17):
>>> =A0 =A0 =A0x86-64: Fix alignment of jiffies variable
>>> =A0 =A0 =A0x86-64: Document some of entry_64.S
>>> =A0 =A0 =A0x86-64: Give vvars their own page
>>> =A0 =A0 =A0x86-64: Remove kernel.vsyscall64 sysctl
>>> =A0 =A0 =A0x86-64: Map the HPET NX
>>> =A0 =A0 =A0x86-64: Remove vsyscall number 3 (venosys)
>>> =A0 =A0 =A0x86-64: Fill unused parts of the vsyscall page with 0xcc
>>> =A0 =A0 =A0x86-64: Emulate legacy vsyscalls
>>> =A0 =A0 =A0x86-64: Improve vsyscall emulation CS and RIP handling
>>> =A0 =A0 =A0x86: Make alternative instruction pointers relative
>>
>> Bisecting this BUG:
>>
>> CPU: Intel QEMU Virtual CPU version 0.13.0 stepping 03
>> BUG: unable to handle kernel paging request at 8277e54c
>> IP: [<c13765fb>] apply_alternatives+0xc3/0x18a
>> *pde =3D 00000000
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>>
>> Pid: 0, comm: swapper Not tainted 3.1.0-rc3 #20 Bochs Bochs
>> EIP: 0060:[<c13765fb>] EFLAGS: 00000286 CPU: 0
>> EIP is at apply_alternatives+0xc3/0x18a
>> EAX: ffffffff EBX: c13bee40 ECX: 00000005 EDX: 8277e54c
>> ESI: 8277e54c EDI: c1349e9e EBP: c1349fa8 ESP: c1349e70
>> =A0DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>> Process swapper (pid: 0, ti=3Dc1348000 task=3Dc134e340 task.ti=3Dc134800=
0)
>> Stack:
>> =A000000002 c135d7c0 c11418a0 00000db8 c1349e9e 82655b12 00000005 8277e5=
4c
>> =A0c13bf6ec c1349e05 05000086 f6890046 00f69000 c1349eb0 00000086 000000=
00
>> =A000000046 c1349ec0 00000046 00000000 c1349edc c101f29c 00000dc5 000000=
00
>> Call Trace:
>> =A0[<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
>> =A0[<c101f29c>] ? console_unlock+0x10c/0x150
>> =A0[<c10039c3>] ? do_IRQ+0x43/0xa0
>> =A0[<c12975a9>] ? common_interrupt+0x29/0x30
>> =A0[<c1294d59>] ? printk+0x18/0x1f
>> =A0[<c139070b>] ? print_cpu_info+0x93/0x11f
>> =A0[<c13766d9>] alternative_instructions+0x17/0x32
>> =A0[<c1377552>] check_bugs+0x91/0x93
>> =A0[<c13716b6>] start_kernel+0x289/0x294
>> =A0[<c13711b7>] ? loglevel+0x1a/0x1a
>> =A0[<c13710b3>] i386_start_kernel+0xb3/0xbb
>> Code: ec fe ff ff 8d 0c 0b 89 8d dc fe ff ff 8d 54 13 04 8b bd d8 fe
>> ff ff 89 95 e4 fe ff ff 89 b5 e0 fe ff ff 8b 8d e0 fe ff ff 89 d6 <f3>
>> a4 80 bd f6 fe ff ff e8 75 17 80 bd ec fe ff ff 05 75 0e 89
>> EIP: [<c13765fb>] apply_alternatives+0xc3/0x18a SS:ESP 0068:c1349e70
>> CR2: 000000008277e54c
>> ---[ end trace 4eaa2a86a8e2da22 ]---
>> Kernel panic - not syncing: Attempted to kill the idle task!
>> Pid: 0, comm: swapper Tainted: G =A0 =A0 =A0D =A0 =A0 3.1.0-rc3 #20
>> Call Trace:
>> =A0[<c1294d59>] ? printk+0x18/0x1f
>> =A0[<c1294c4a>] panic+0x57/0x14e
>> =A0[<c10221a1>] do_exit+0x201/0x290
>> =A0[<c1004ace>] oops_end+0x6e/0x90
>> =A0[<c1294d59>] ? printk+0x18/0x1f
>> =A0[<c1013efc>] no_context+0xbc/0x150
>> =A0[<c1013fc0>] __bad_area_nosemaphore+0x30/0x170
>> =A0[<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
>> =A0[<c1014112>] bad_area_nosemaphore+0x12/0x20
>> =A0[<c101466f>] do_page_fault+0x21f/0x360
>> =A0[<c105c070>] ? get_page_from_freelist+0x110/0x300
>> =A0[<c1023b24>] ? irq_exit+0x54/0x90
>> =A0[<c10039c3>] ? do_IRQ+0x43/0xa0
>> =A0[<c1140e31>] ? wait_for_xmitr+0x31/0x90
>> =A0[<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
>> =A0[<c1296df8>] error_code+0x58/0x60
>> =A0[<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
>> =A0[<c13765fb>] ? apply_alternatives+0xc3/0x18a
>> =A0[<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
>> =A0[<c101f29c>] ? console_unlock+0x10c/0x150
>> =A0[<c10039c3>] ? do_IRQ+0x43/0xa0
>> =A0[<c12975a9>] ? common_interrupt+0x29/0x30
>> =A0[<c1294d59>] ? printk+0x18/0x1f
>> =A0[<c139070b>] ? print_cpu_info+0x93/0x11f
>> =A0[<c13766d9>] alternative_instructions+0x17/0x32
>> =A0[<c1377552>] check_bugs+0x91/0x93
>> =A0[<c13716b6>] start_kernel+0x289/0x294
>> =A0[<c13711b7>] ? loglevel+0x1a/0x1a
>> =A0[<c13710b3>] i386_start_kernel+0xb3/0xbb
>> QEMU: Terminated
>>
>> lead me to that commit:
>>
>> commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
>> Author: Andy Lutomirski <luto@mit.edu>
>> Date: =A0 Wed Jul 13 09:24:10 2011 -0400
>>
>> =A0 =A0x86: Make alternative instruction pointers relative
>>
>> =A0 =A0This save a few bytes on x86-64 and means that future patches can
>> =A0 =A0apply alternatives to unrelocated code.
>>
>> =A0 =A0Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> =A0 =A0Link: http://lkml.kernel.org/r/ff64a6b9a1a3860ca4a7b8b6dc7b4754f9=
491cd7.1310563276.git.luto@mit.edu
>> =A0 =A0Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>>
>
> I probably missed a hardcoded alternative entry that depends on
> config. =A0Can you send me your System.map and the output of objdump -s
> -j .altinstructions vmlinux?
>
see attached.

> I'm also having issues building from your .config. =A0Building
> 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93 asks me about Moorestown MID
> platform, Ethernet, etc.
>
yes, the config is against -rc3. An `oldnoconfig' should do the job
before the build.

 - Arnaud

> --Andy
>

--000e0cd2db7cd452f604ab54f03c
Content-Type: text/plain; charset=US-ASCII; name="altinstructions.txt"
Content-Disposition: attachment; filename="altinstructions.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grrt33lm0

Cm9iai9uZXh0LWJpc2VjdC92bWxpbnV4OiAgICAgZmlsZSBmb3JtYXQgZWxmMzItaTM4NgoKQ29u
dGVudHMgb2Ygc2VjdGlvbiAuYWx0aW5zdHJ1Y3Rpb25zOgogYzEzYmVkYzggNWUyNmM0ZmYgMjAw
OTAwMDAgMWEwMDA1MDMgM2IyOGM0ZmYgIF4mLi4gLi4uLi4uLjsoLi4KIGMxM2JlZGQ4IDAwMDAw
MDAwIDlhMDAwMjAwIDNlMjhjNGZmIDBiMDkwMDAwICAuLi4uLi4uLj4oLi4uLi4uCiBjMTNiZWRl
OCBlNDAwMDMwMyA0YTI4YzRmZiAwMjA5MDAwMCA2YTAwMGEwOCAgLi4uLkooLi4uLi4uai4uLgog
YzEzYmVkZjggNzAyOGM0ZmYgMDAwMDAwMDAgMTgwMDAyMDAgNTAyYWM0ZmYgIHAoLi4uLi4uLi4u
LlAqLi4KIGMxM2JlZTA4IDAwMDAwMDAwIDlhMDAwNTAwIDU2MmFjNGZmIGU2MDgwMDAwICAuLi4u
Li4uLlYqLi4uLi4uCiBjMTNiZWUxOCBlNDAwMDMwMyA2NjJhYzRmZiBkZDA4MDAwMCA2YTAwMGEw
OCAgLi4uLmYqLi4uLi4uai4uLgogYzEzYmVlMjggOGIyYWM0ZmYgZDkwODAwMDAgMTkwMDA0MDMg
M2MyYmM0ZmYgIC4qLi4uLi4uLi4uLjwrLi4KIGMxM2JlZTM4IDAwMDAwMDAwIDE4MDAwMjAwIGQy
NmMyOWMxIDA4ZjczYmMxICAuLi4uLi4uLi5sKS4uLjsuCiBjMTNiZWU0OCAxOTAwMDUwNSAwZjQ2
YzRmZiAwMDAwMDAwMCA5YTAwMDUwMCAgLi4uLi5GLi4uLi4uLi4uLgogYzEzYmVlNTggMTU0NmM0
ZmYgYjEwODAwMDAgZTQwMDAzMDMgMTQ0N2M0ZmYgIC5GLi4uLi4uLi4uLi5HLi4KIGMxM2JlZTY4
IDAwMDAwMDAwIDE4MDAwMjAwIDIzNDdjNGZmIDljMDgwMDAwICAuLi4uLi4uLiNHLi4uLi4uCiBj
MTNiZWU3OCA2YTAwMGEwOCA2ZjQ4YzRmZiAwMDAwMDAwMCA5YTAwMDIwMCAgai4uLm9ILi4uLi4u
Li4uLgogYzEzYmVlODggOWU0OGM0ZmYgOGMwODAwMDAgMTgwMDAzMDMgOGY1M2M0ZmYgIC5ILi4u
Li4uLi4uLi5TLi4KIGMxM2JlZTk4IDgzMDgwMDAwIDE5MDAwNTAzIDhlNTNjNGZmIDdhMDgwMDAw
ICAuLi4uLi4uLi5TLi56Li4uCiBjMTNiZWVhOCAxOTAwMDUwMyA0OTljYzRmZiAwMDAwMDAwMCBl
NDAwMDIwMCAgLi4uLkkuLi4uLi4uLi4uLgogYzEzYmVlYjggOTU5ZGM0ZmYgMDAwMDAwMDAgOWEw
MDA1MDAgOWI5ZGM0ZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMxM2JlZWM4IDU5MDgwMDAwIGU0MDAw
MzAzIGFiOWRjNGZmIDUwMDgwMDAwICBZLi4uLi4uLi4uLi5QLi4uCiBjMTNiZWVkOCA2YTAwMGEw
OCAwYzllYzRmZiAwMDAwMDAwMCAxODAwMDIwMCAgai4uLi4uLi4uLi4uLi4uLgogYzEzYmVlZTgg
ZTM5ZWM0ZmYgMDAwMDAwMDAgZTQwMDAyMDAgODE5ZmM0ZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMx
M2JlZWY4IDAwMDAwMDAwIGU0MDAwMjAwIGIwYTJjNGZmIDAwMDAwMDAwICAuLi4uLi4uLi4uLi4u
Li4uCiBjMTNiZWYwOCBlNDAwMDIwMCAzMmEzYzRmZiAwMDAwMDAwMCBlNDAwMDIwMCAgLi4uLjIu
Li4uLi4uLi4uLgogYzEzYmVmMTggYWNhNGM0ZmYgMDAwMDAwMDAgOWEwMDA1MDAgYjJhNGM0ZmYg
IC4uLi4uLi4uLi4uLi4uLi4KIGMxM2JlZjI4IDA0MDgwMDAwIGU0MDAwMzAzIGMyYTRjNGZmIGZi
MDcwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZWYzOCA2YTAwMGEwOCAzOGE1YzRmZiAwMDAw
MDAwMCAxODAwMDIwMCAgai4uLjguLi4uLi4uLi4uLgogYzEzYmVmNDggZDY4NGZiZmYgMDAwMDAw
MDAgOWEwMDA1MDAgZGE4NGZiZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMxM2JlZjU4IGRmMDcwMDAw
IGU0MDAwMzAzIGYzODRmYmZmIGQ2MDcwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZWY2OCA2
YTAwMGEwOCA0Nzg1ZmJmZiAwMDAwMDAwMCAxODAwMDIwMCAgai4uLkcuLi4uLi4uLi4uLgogYzEz
YmVmNzggMzJjZWM0ZmYgYzYwNzAwMDAgMDgwMDA1MDUgNTNjZWM0ZmYgIDIuLi4uLi4uLi4uLlMu
Li4KIGMxM2JlZjg4IGJmMDcwMDAwIDA4MDAwNTA0IDk4Y2VjNGZmIGI3MDcwMDAwICAuLi4uLi4u
Li4uLi4uLi4uCiBjMTNiZWY5OCAwODAwMDUwNSA5YmNlYzRmZiBiMDA3MDAwMCAwODAwMDUwNSAg
Li4uLi4uLi4uLi4uLi4uLgogYzEzYmVmYTggZjVjZWM0ZmYgYTkwNzAwMDAgMDgwMDA1MDUgMjBk
ZGM0ZmYgIC4uLi4uLi4uLi4uLiAuLi4KIGMxM2JlZmI4IGEyMDcwMDAwIGQ3MDAwMjAyIDI4ZGRj
NGZmIDk4MDcwMDAwICAuLi4uLi4uLiguLi4uLi4uCiBjMTNiZWZjOCBkNzAwMDIwMiBhNmRkYzRm
ZiA4ZTA3MDAwMCBkNzAwMDIwMiAgLi4uLi4uLi4uLi4uLi4uLgogYzEzYmVmZDggMjNkZWM0ZmYg
ODQwNzAwMDAgZDcwMDAyMDIgMzBkZWM0ZmYgICMuLi4uLi4uLi4uLjAuLi4KIGMxM2JlZmU4IDdh
MDcwMDAwIGQ3MDAwMjAyIDMzZTZjNGZmIDcwMDcwMDAwICB6Li4uLi4uLjMuLi5wLi4uCiBjMTNi
ZWZmOCAwODAwMDUwNSBlYWU2YzRmZiA2OTA3MDAwMCAwODAwMDUwNSAgLi4uLi4uLi5pLi4uLi4u
LgogYzEzYmYwMDggMjhlN2M0ZmYgNjIwNzAwMDAgMDgwMDA1MDUgZGFlN2M0ZmYgICguLi5iLi4u
Li4uLi4uLi4KIGMxM2JmMDE4IDViMDcwMDAwIDA4MDAwNTA1IDAyZWNjNGZmIDU0MDcwMDAwICBb
Li4uLi4uLi4uLi5ULi4uCiBjMTNiZjAyOCBkNzAwMDIwMiAwOGVjYzRmZiA0YTA3MDAwMCBkNzAw
MDIwMiAgLi4uLi4uLi5KLi4uLi4uLgogYzEzYmYwMzggMzVlZWM0ZmYgNDAwNzAwMDAgZDcwMDAy
MDIgNDNlZWM0ZmYgIDUuLi5ALi4uLi4uLkMuLi4KIGMxM2JmMDQ4IDM2MDcwMDAwIGQ3MDAwMjAy
IGQyZWZjNGZmIDJjMDcwMDAwICA2Li4uLi4uLi4uLi4sLi4uCiBjMTNiZjA1OCA5NzAwMDUwNCBm
NjBhYzVmZiAyNDA3MDAwMCBkNzAwMDIwMiAgLi4uLi4uLi4kLi4uLi4uLgogYzEzYmYwNjggMDIw
YmM1ZmYgMWEwNzAwMDAgZDcwMDAyMDIgMTY1NGM1ZmYgIC4uLi4uLi4uLi4uLi5ULi4KIGMxM2Jm
MDc4IDEwMDcwMDAwIDNmMDAwNDAzIDU3NWVjNWZmIDA3MDcwMDAwICAuLi4uPy4uLldeLi4uLi4u
CiBjMTNiZjA4OCAxYTAwMDUwMyA2NzVlYzVmZiBmZTA2MDAwMCAxYTAwMDUwMyAgLi4uLmdeLi4u
Li4uLi4uLgogYzEzYmYwOTggZGNjNmM3ZmYgZjUwNjAwMDAgMDgwMDA1MDQgZTJjOGM3ZmYgIC4u
Li4uLi4uLi4uLi4uLi4KIGMxM2JmMGE4IGVkMDYwMDAwIDA4MDAwNTA0IGQ1M2ZjOGZmIGU1MDYw
MDAwICAuLi4uLi4uLi4/Li4uLi4uCiBjMTNiZjBiOCA5NzAwMDUwNCA3YWQ2YzhmZiBkZDA2MDAw
MCAxOTAwMDQwMyAgLi4uLnouLi4uLi4uLi4uLgogYzEzYmYwYzggMmRlMmM4ZmYgZDQwNjAwMDAg
MDgwMDA1MDUgMzdlMmM4ZmYgIC0uLi4uLi4uLi4uLjcuLi4KIGMxM2JmMGQ4IGNkMDYwMDAwIDA4
MDAwNTA1IGFhZTVjOGZmIGM2MDYwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjBlOCAwODAw
MDUwNSBiNGU1YzhmZiBiZjA2MDAwMCAwODAwMDUwNSAgLi4uLi4uLi4uLi4uLi4uLgogYzEzYmYw
ZjggMTBlNmM4ZmYgYjgwNjAwMDAgMDgwMDA1MDUgYzNlNmM4ZmYgIC4uLi4uLi4uLi4uLi4uLi4K
IGMxM2JmMTA4IGIxMDYwMDAwIDA4MDAwNTA1IGRlZTZjOGZmIGFhMDYwMDAwICAuLi4uLi4uLi4u
Li4uLi4uCiBjMTNiZjExOCAwODAwMDUwNSA3OWU3YzhmZiBhMzA2MDAwMCAwODAwMDUwNSAgLi4u
LnkuLi4uLi4uLi4uLgogYzEzYmYxMjggY2FlN2M4ZmYgOWMwNjAwMDAgMDgwMDA1MDUgOGZlOGM4
ZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMxM2JmMTM4IDk1MDYwMDAwIDA4MDAwNTA1IGE0ZWFjOGZm
IDhlMDYwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjE0OCAwODAwMDUwNSAyZGViYzhmZiA4
NzA2MDAwMCAwODAwMDUwNCAgLi4uLi0uLi4uLi4uLi4uLgogYzEzYmYxNTggNzBmMGM4ZmYgN2Yw
NjAwMDAgMDgwMDA1MDUgODNmMGM4ZmYgIHAuLi4uLi4uLi4uLi4uLi4KIGMxM2JmMTY4IDc4MDYw
MDAwIDA4MDAwNTA1IDgwZjljOGZmIDcxMDYwMDAwICB4Li4uLi4uLi4uLi5xLi4uCiBjMTNiZjE3
OCAwODAwMDUwNSA4NGY5YzhmZiA2YTA2MDAwMCAwODAwMDUwNSAgLi4uLi4uLi5qLi4uLi4uLgog
YzEzYmYxODggMDhmY2M4ZmYgNjMwNjAwMDAgMDgwMDA1MDUgMTBmY2M4ZmYgIC4uLi5jLi4uLi4u
Li4uLi4KIGMxM2JmMTk4IDVjMDYwMDAwIDA4MDAwNTA1IGZhZmNjOGZmIDU1MDYwMDAwICBcLi4u
Li4uLi4uLi5VLi4uCiBjMTNiZjFhOCAwODAwMDUwNSAwMmZkYzhmZiA0ZTA2MDAwMCAwODAwMDUw
NSAgLi4uLi4uLi5OLi4uLi4uLgogYzEzYmYxYjggZjVmZGM4ZmYgNDcwNjAwMDAgMDgwMDA1MDUg
ZjlmZGM4ZmYgIC4uLi5HLi4uLi4uLi4uLi4KIGMxM2JmMWM4IDQwMDYwMDAwIDA4MDAwNTA1IDE0
ZmVjOGZmIDM5MDYwMDAwICBALi4uLi4uLi4uLi45Li4uCiBjMTNiZjFkOCAwODAwMDUwNSAyY2Zl
YzhmZiAzMjA2MDAwMCAwODAwMDUwNSAgLi4uLiwuLi4yLi4uLi4uLgogYzEzYmYxZTggMWYxM2M5
ZmYgMmIwNjAwMDAgMDgwMDA1MDUgN2MxM2M5ZmYgIC4uLi4rLi4uLi4uLnwuLi4KIGMxM2JmMWY4
IDI0MDYwMDAwIDA4MDAwNTA1IDg4MThjOWZmIDFkMDYwMDAwICAkLi4uLi4uLi4uLi4uLi4uCiBj
MTNiZjIwOCAwODAwMDUwNSA4YTE4YzlmZiAxNjA2MDAwMCAwODAwMDUwNSAgLi4uLi4uLi4uLi4u
Li4uLgogYzEzYmYyMTggYjYxOGM5ZmYgMGYwNjAwMDAgMDgwMDA1MDUgZDQxOGM5ZmYgIC4uLi4u
Li4uLi4uLi4uLi4KIGMxM2JmMjI4IDA4MDYwMDAwIDA4MDAwNTA1IDBlMTljOWZmIDAxMDYwMDAw
ICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjIzOCAwODAwMDUwNSA1MzE5YzlmZiBmYTA1MDAwMCAw
ODAwMDUwNSAgLi4uLlMuLi4uLi4uLi4uLgogYzEzYmYyNDggYTIxOWM5ZmYgZjMwNTAwMDAgMDgw
MDA1MDUgYTIxOWM5ZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMxM2JmMjU4IGVjMDUwMDAwIDA4MDAw
NTA1IGEyMTljOWZmIGU1MDUwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjI2OCAwODAwMDUw
NSBiNTIwYzlmZiBkZTA1MDAwMCAwODAwMDUwNSAgLi4uLi4gLi4uLi4uLi4uLgogYzEzYmYyNzgg
YjcyMGM5ZmYgZDcwNTAwMDAgMDgwMDA1MDUgYjkyMGM5ZmYgIC4gLi4uLi4uLi4uLi4gLi4KIGMx
M2JmMjg4IGQwMDUwMDAwIDA4MDAwNTA1IGJlMjBjOWZmIGM5MDUwMDAwICAuLi4uLi4uLi4gLi4u
Li4uCiBjMTNiZjI5OCAwODAwMDUwNSBjMzIwYzlmZiBjMjA1MDAwMCAwODAwMDUwNSAgLi4uLi4g
Li4uLi4uLi4uLgogYzEzYmYyYTggZDYyY2M5ZmYgYmIwNTAwMDAgMDgwMDA1MDUgYTAzY2M5ZmYg
IC4sLi4uLi4uLi4uLi48Li4KIGMxM2JmMmI4IGI0MDUwMDAwIDA4MDAwNTA1IGMxM2NjOWZmIGFk
MDUwMDAwICAuLi4uLi4uLi48Li4uLi4uCiBjMTNiZjJjOCAwODAwMDUwNSBhZjQ2YzlmZiBhNjA1
MDAwMCAwODAwMDUwNSAgLi4uLi5GLi4uLi4uLi4uLgogYzEzYmYyZDggM2M0N2M5ZmYgOWYwNTAw
MDAgMDgwMDA1MDUgNDg0YWM5ZmYgIDxHLi4uLi4uLi4uLkhKLi4KIGMxM2JmMmU4IDk4MDUwMDAw
IDA4MDAwNTA1IGYzZjlmYmZmIDkxMDUwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjJmOCA5
NzAwMDUwNCBhZjMzZmRmZiA4OTA1MDAwMCAzZjAwMDQwMyAgLi4uLi4zLi4uLi4uPy4uLgogYzEz
YmYzMDggYjQzM2ZkZmYgODAwNTAwMDAgM2YwMDA0MDMgYzExOWNhZmYgIC4zLi4uLi4uPy4uLi4u
Li4KIGMxM2JmMzE4IDc3MDUwMDAwIDNmMDAwNDAzIGQ3MWZjYWZmIDZlMDUwMDAwICB3Li4uPy4u
Li4uLi5uLi4uCiBjMTNiZjMyOCAzZjAwMDQwMyA5YzZhY2FmZiA2NTA1MDAwMCAxOTAwMDQwMyAg
Py4uLi5qLi5lLi4uLi4uLgogYzEzYmYzMzggYmE2YWNhZmYgNWMwNTAwMDAgMTkwMDA0MDMgZTMw
YmNjZmYgIC5qLi5cLi4uLi4uLi4uLi4KIGMxM2JmMzQ4IDUzMDUwMDAwIDE5MDAwNTAzIGE5YzBj
Y2ZmIDRhMDUwMDAwICBTLi4uLi4uLi4uLi5KLi4uCiBjMTNiZjM1OCAxOTAwMDQwMyAxYmMzY2Nm
ZiA0MTA1MDAwMCAxOTAwMDQwMyAgLi4uLi4uLi5BLi4uLi4uLgogYzEzYmYzNjggZGFkYmNjZmYg
MzgwNTAwMDAgMTkwMDA0MDMgNTVmYmNjZmYgIC4uLi44Li4uLi4uLlUuLi4KIGMxM2JmMzc4IDJm
MDUwMDAwIDNmMDAwNDAzIDRlNmFjZWZmIDI2MDUwMDAwICAvLi4uPy4uLk5qLi4mLi4uCiBjMTNi
ZjM4OCAzZjAwMDQwMyBiOTZmY2VmZiAxZDA1MDAwMCAzZjAwMDQwMyAgPy4uLi5vLi4uLi4uPy4u
LgogYzEzYmYzOTggM2VlMGQ0ZmYgMTQwNTAwMDAgNzEwMDAzMDMgMzVlMGQ0ZmYgID4uLi4uLi4u
cS4uLjUuLi4KIGMxM2JmM2E4IDBiMDUwMDAwIDcyMDAwMzAzIDNhZTBkNGZmIDAyMDUwMDAwICAu
Li4uci4uLjouLi4uLi4uCiBjMTNiZjNiOCA3MTAwMDMwMyAzMWUwZDRmZiBmOTA0MDAwMCA3MjAw
MDMwMyAgcS4uLjEuLi4uLi4uci4uLgogYzEzYmYzYzggMDYxNGQ1ZmYgZjAwNDAwMDAgOTcwMDA1
MDQgMmUxNGQ1ZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMxM2JmM2Q4IGU4MDQwMDAwIDk3MDAwNTA0
IGZkMTJkN2ZmIGUwMDQwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjNlOCAxOTAwMDUwMyA2
ZDE0ZDdmZiBkNzA0MDAwMCAxYTAwMDUwMyAgLi4uLm0uLi4uLi4uLi4uLgogYzEzYmYzZjggZTQx
NGQ3ZmYgY2UwNDAwMDAgMWEwMDA1MDMgMTMwM2Q5ZmYgIC4uLi4uLi4uLi4uLi4uLi4KIGMxM2Jm
NDA4IGM1MDQwMDAwIDE5MDAwNTAzIDI1ZjZkOWZmIGJjMDQwMDAwICAuLi4uLi4uLiUuLi4uLi4u
CiBjMTNiZjQxOCAxYTAwMDUwMyA5ZmQzZGJmZiBiMzA0MDAwMCAxYTAwMDUwMyAgLi4uLi4uLi4u
Li4uLi4uLgogYzEzYmY0MjggZDc3YWRjZmYgYWEwNDAwMDAgMTkwMDA1MDMgN2Q4MGRjZmYgIC56
Li4uLi4uLi4uLn0uLi4KIGMxM2JmNDM4IGExMDQwMDAwIDE5MDAwNDAzIDc1ODFkY2ZmIDk4MDQw
MDAwICAuLi4uLi4uLnUuLi4uLi4uCiBjMTNiZjQ0OCAxYTAwMDUwMyAyMzg2ZGNmZiA4ZjA0MDAw
MCAxYTAwMDUwMyAgLi4uLiMuLi4uLi4uLi4uLgogYzEzYmY0NTggMzE4NmRjZmYgODYwNDAwMDAg
MTkwMDA0MDMgNGY4NmRjZmYgIDEuLi4uLi4uLi4uLk8uLi4KIGMxM2JmNDY4IDdkMDQwMDAwIDE5
MDAwNDAzIGRhOGFkY2ZmIDc0MDQwMDAwICB9Li4uLi4uLi4uLi50Li4uCiBjMTNiZjQ3OCAxOTAw
MDUwMyA1MjhlZGNmZiA2YjA0MDAwMCAxOTAwMDUwMyAgLi4uLlIuLi5rLi4uLi4uLgogYzEzYmY0
ODggMzhhM2RjZmYgNjIwNDAwMDAgMWEwMDA1MDMgZGY0OGRlZmYgIDguLi5iLi4uLi4uLi5ILi4K
IGMxM2JmNDk4IDU5MDQwMDAwIDE5MDAwNTAzIGNiNDlkZWZmIDUwMDQwMDAwICBZLi4uLi4uLi5J
Li5QLi4uCiBjMTNiZjRhOCAxOTAwMDUwMyAyYzY0ZGVmZiA0NzA0MDAwMCAxOTAwMDUwMyAgLi4u
LixkLi5HLi4uLi4uLgogYzEzYmY0YjggNGM2NWRlZmYgM2UwNDAwMDAgMWEwMDA1MDMgNWM2NWRl
ZmYgIExlLi4+Li4uLi4uLlxlLi4KIGMxM2JmNGM4IDM1MDQwMDAwIDE5MDAwNDAzIDc2NjVkZWZm
IDJjMDQwMDAwICA1Li4uLi4uLnZlLi4sLi4uCiBjMTNiZjRkOCAxOTAwMDQwMyBhMjY4ZGVmZiAy
MzA0MDAwMCAxOTAwMDUwMyAgLi4uLi5oLi4jLi4uLi4uLgogYzEzYmY0ZTggYzg2YmRlZmYgMWEw
NDAwMDAgMTkwMDA1MDMgNjM2Y2RlZmYgIC5rLi4uLi4uLi4uLmNsLi4KIGMxM2JmNGY4IDExMDQw
MDAwIDE5MDAwNDAzIDUyNmRkZWZmIDA4MDQwMDAwICAuLi4uLi4uLlJtLi4uLi4uCiBjMTNiZjUw
OCAxYTAwMDUwMyA4ZjcwZGVmZiBmZjAzMDAwMCAxYTAwMDUwMyAgLi4uLi5wLi4uLi4uLi4uLgog
YzEzYmY1MTggOGU3MGRlZmYgZjYwMzAwMDAgMTkwMDA0MDMgYjU3MGRlZmYgIC5wLi4uLi4uLi4u
Li5wLi4KIGMxM2JmNTI4IGVkMDMwMDAwIDE5MDAwNDAzIDMwNzZkZWZmIGU0MDMwMDAwICAuLi4u
Li4uLjB2Li4uLi4uCiBjMTNiZjUzOCAxYTAwMDUwMyBhNDExZGZmZiBkYjAzMDAwMCAxYTAwMDUw
MyAgLi4uLi4uLi4uLi4uLi4uLgogYzEzYmY1NDggNjEyMmRmZmYgZDIwMzAwMDAgMTkwMDA1MDMg
NTYzZGRmZmYgIGEiLi4uLi4uLi4uLlY9Li4KIGMxM2JmNTU4IGM5MDMwMDAwIDE5MDAwNTAzIGZi
NDZkZmZmIGMwMDMwMDAwICAuLi4uLi4uLi5GLi4uLi4uCiBjMTNiZjU2OCAxYTAwMDUwMyBmYzQ2
ZGZmZiBiNzAzMDAwMCAxOTAwMDQwMyAgLi4uLi5GLi4uLi4uLi4uLgogYzEzYmY1NzggMjA0N2Rm
ZmYgYWUwMzAwMDAgMTkwMDA0MDMgNGIwMGUwZmYgICBHLi4uLi4uLi4uLksuLi4KIGMxM2JmNTg4
IGE1MDMwMDAwIDE5MDAwNTAzIDkwMDNlMGZmIDljMDMwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBj
MTNiZjU5OCAxYTAwMDUwMyA5ZDA3ZTBmZiA5MzAzMDAwMCAxOTAwMDUwMyAgLi4uLi4uLi4uLi4u
Li4uLgogYzEzYmY1YTggZjcwZGUwZmYgOGEwMzAwMDAgMTkwMDA0MDMgNGUwZWUwZmYgIC4uLi4u
Li4uLi4uLk4uLi4KIGMxM2JmNWI4IDgxMDMwMDAwIDFhMDAwNTAzIDg4MGVlMGZmIDc4MDMwMDAw
ICAuLi4uLi4uLi4uLi54Li4uCiBjMTNiZjVjOCAxOTAwMDQwMyAwNzMxZTBmZiA2ZjAzMDAwMCAx
OTAwMDUwMyAgLi4uLi4xLi5vLi4uLi4uLgogYzEzYmY1ZDggM2I2M2UwZmYgNjYwMzAwMDAgMWEw
MDA1MDMgZTU2YmUwZmYgIDtjLi5mLi4uLi4uLi5rLi4KIGMxM2JmNWU4IDVkMDMwMDAwIDE5MDAw
NTAzIGRjNmVlMGZmIDU0MDMwMDAwICBdLi4uLi4uLi5uLi5ULi4uCiBjMTNiZjVmOCAxOTAwMDQw
MyA3MjZmZTBmZiA0YjAzMDAwMCAxYTAwMDUwMyAgLi4uLnJvLi5LLi4uLi4uLgogYzEzYmY2MDgg
ODU2ZmUwZmYgNDIwMzAwMDAgMTkwMDA0MDMgMjU5NGUxZmYgIC5vLi5CLi4uLi4uLiUuLi4KIGMx
M2JmNjE4IDM5MDMwMDAwIDE5MDAwNTAzIDBkOWFlMWZmIDMwMDMwMDAwICA5Li4uLi4uLi4uLi4w
Li4uCiBjMTNiZjYyOCAxOTAwMDUwMyBmMjlhZTFmZiAyNzAzMDAwMCAxYTAwMDUwMyAgLi4uLi4u
Li4nLi4uLi4uLgogYzEzYmY2MzggMDA5YmUxZmYgMWUwMzAwMDAgMTkwMDA0MDMgM2I5YmUxZmYg
IC4uLi4uLi4uLi4uLjsuLi4KIGMxM2JmNjQ4IDE1MDMwMDAwIDE5MDAwNDAzIDRjOWJlMWZmIDBj
MDMwMDAwICAuLi4uLi4uLkwuLi4uLi4uCiBjMTNiZjY1OCAxOTAwMDQwMyAwNGEzZTFmZiAwMzAz
MDAwMCAxYTAwMDUwMyAgLi4uLi4uLi4uLi4uLi4uLgogYzEzYmY2NjggZTQ0MmUyZmYgZmEwMjAw
MDAgMWEwMDA1MDMgNzU1NWUyZmYgIC5CLi4uLi4uLi4uLnVVLi4KIGMxM2JmNjc4IGYxMDIwMDAw
IDFhMDAwNTAzIDg3NDllM2ZmIGU4MDIwMDAwICAuLi4uLi4uLi5JLi4uLi4uCiBjMTNiZjY4OCAz
ZjAwMDQwMyBhYjQ5ZTNmZiBkZjAyMDAwMCAzZjAwMDQwMyAgPy4uLi5JLi4uLi4uPy4uLgogYzEz
YmY2OTggYmEzM2U0ZmYgZDYwMjAwMDAgOTcwMDA1MDQgYjczM2U0ZmYgIC4zLi4uLi4uLi4uLi4z
Li4KIGMxM2JmNmE4IGNlMDIwMDAwIDk3MDAwNTA0IDIyNWNlNGZmIGM2MDIwMDAwICAuLi4uLi4u
LiJcLi4uLi4uCiBjMTNiZjZiOCAxOTAwMDQwMyAzNTJlZTVmZiBiZDAyMDAwMCA5NzAwMDUwNCAg
Li4uLjUuLi4uLi4uLi4uLgogYzEzYmY2YzggM2IyZWU1ZmYgYjUwMjAwMDAgOTcwMDA1MDQgYTk5
N2U4ZmYgIDsuLi4uLi4uLi4uLi4uLi4KIGMxM2JmNmQ4IGFkMDIwMDAwIDE5MDAwNDAzIGU3OTNl
Y2ZmIGE0MDIwMDAwICAuLi4uLi4uLi4uLi4uLi4uCiBjMTNiZjZlOCAxYTAwMDUwMyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgLi4uLiAgICAgICAgICAgIAo=
--000e0cd2db7cd452f604ab54f03c--
