Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1EDKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:16:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1EDKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=VSlR/K6hV70Wupuavj1aJNDXr+gIyuER0X3GEJbV8mdwk2793NuMe9MZpwbLV8TQ/J
         WASrwc1rXAZexV7CZHW39HFfPUesxkyInii3+tlCRYIoKB6nmw1r2J2Tp7wIPGZU9wj+
         3AOYCHbIr++OkMDvNxkNorVAVm5XTuqNvNpAI=
MIME-Version: 1.0
In-Reply-To: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com>
References: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com>
Date: Wed, 4 May 2011 15:46:55 +0530
Message-ID: <BANLkTi=oZ0Mr33rL=QNmzDuaKLNezoKBXg@mail.gmail.com>
Subject: Fwd: [ARM]crash on 2.6.35.11
From: naveen yadav <yad.naveen@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        linux newbie <linux.newbie79@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000325554c7e5aee1104a2708e54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000325554c7e5aee1104a2708e54
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Attaching test case

Dear all,

We are running linux kernel 2.6.35.11 on Cortex a-8. when I run a
simple program expect to give oom.
=A0But it crash with following crash log

./DiffSize

BUG: Bad page state in process DiffSize =A0pfn:50769c
page:c9907380 count:892679477 mapcount:892679478 mapping:35353535
index:0x35353535
page flags: 0x35353535(locked|referenced|dirty|lru|owner_priv_1|reserved|pr=
ivate_2|writeback|swapcache|reclaim|swapbacked|unevictable)
Backtrace:
[<c0023b90>] (dump_backtrace+0x0/0x110) from [<c02de8f0>] (dump_stack+0x18/=
0x1c)
=A0r6:c9907380 r5:c040674c r4:c9907380 r3:00000000
[<c02de8d8>] (dump_stack+0x0/0x1c) from [<c007b60c>] (bad_page+0xe0/0x10c)
[<c007b52c>] (bad_page+0x0/0x10c) from [<c007c864>]
(get_page_from_freelist+0x364/0x4bc)
=A0r5:c03cd21c r4:00000000
[<c007c500>] (get_page_from_freelist+0x0/0x4bc) from [<c007cac8>]
(__alloc_pages_nodemask+0x10c/0x578)
[<c007c9bc>] (__alloc_pages_nodemask+0x0/0x578) from [<c008b3e0>]
(handle_mm_fault+0x218/0xd68)
[<c008b1c8>] (handle_mm_fault+0x0/0xd68) from [<c0026514>]
(do_page_fault+0x10c/0x200)
[<c0026408>] (do_page_fault+0x0/0x200) from [<c001f2bc>]
(do_DataAbort+0x3c/0xa0)
[<c001f280>] (do_DataAbort+0x0/0xa0) from [<c001ff24>]
(ret_from_exception+0x0/0x10)
Exception stack(0xc9281fb0 to 0xc9281ff8)
1fa0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 48166008 00000035 50166008 35353535
1fc0: 072be000 35353535 48ea7f88 4001f080 00000000 00000000 be87e880 be87e8=
6c
1fe0: 48ea8008 be87e844 00008514 400b449c 20000010 ffffffff
=A0r7:4001f080 r6:48ea7f88 r5:35353535 r4:ffffffff
Disabling lock debugging due to kernel taint

regards
Naveen

--000325554c7e5aee1104a2708e54
Content-Type: text/x-csrc; charset=US-ASCII; name="DiffAllocs.c"
Content-Disposition: attachment; filename="DiffAllocs.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gna44cj20

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxtYWxsb2MuaD4KI2luY2x1ZGUgPHN0cmluZy5o
PgoKI2RlZmluZSBTSVpFIDQwOTYKI2RlZmluZSBTVEFSVF9TSVpFIDEwMjQKY2hhciAqcHRyWzEw
MDBdOwoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7CglpbnQgaT0wOwoJdW5zaWdu
ZWQgaW50IGFsbG9jX3NpemUgPSBTVEFSVF9TSVpFOwkKCXNsZWVwKDUpOwoJd2hpbGUoaTwxMDAw
KQoJewoJCQoJCXB0cltpXSA9IChjaGFyKikgbWFsbG9jKGFsbG9jX3NpemUpOwoJCWlmKHB0cltp
XSkKCQkJbWVtc2V0KHB0cltpXSwnNScsYWxsb2Nfc2l6ZSk7CQoJCWFsbG9jX3NpemUgKj0gMjsK
CgkJaSsrOwoJCXNsZWVwKDUpOwoJfQp9Cg==
--000325554c7e5aee1104a2708e54--
