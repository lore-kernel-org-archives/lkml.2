Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2HULEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:04:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36268 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab2HULEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:04:01 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
References: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
Date: Tue, 21 Aug 2012 13:03:59 +0200
Message-ID: <CA+icZUVjr6aaopVAhGRr13RLDy=epdnU30YTHOhjXmrWb2sAjA@mail.gmail.com>
Subject: Re: inux-next: Tree for Aug 21 (call-trace when suspending: PM?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=f46d042c6b8d50904504c7c4950d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d042c6b8d50904504c7c4950d
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 21, 2012 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 21, 2012 at 8:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20120820:
>>
>> The rr tree gained a conflict against Linus' tree.
>>
>> The tip tree still has its build failure so I used the version from
>> next-20120814.
>>
>> The workqueues tree gained a conflict against the hid tree.
>>
>> The drivers-x86 tree still has its build failure so I used the version
>> from next-20120817.
>>
>> The signal tree gained a conflict against Linus' tree.  I have still
>> reverted 3 commits from the signal tree at the request of the arm
>> maintainer.
>>
>> ----------------------------------------------------------------------------
>>
>
> Hi,
>
> I have compiled linux-next (next-20120821) and see the attached
> call-trace when suspending.
> Suspending did NOT work (Xorg seems to cause it) - machine came back to desktop.
>
> With yesterday's next-20120820 I haven't seen this.
>
> I am not sure what is this causing... PM, x86/sched or even VFS?
> Any help for debugging appreciated.
>
> I am on Ubuntu/precise AMD64 and use systemd-v43 as init-system.
>
> Regards,
> - Sedat -

Forgot attachment!
If you don't succeed - try try try...

- Sedat -

--f46d042c6b8d50904504c7c4950d
Content-Type: text/plain; charset=US-ASCII; 
	name="CALL-TRACE_PM-related_3.6.0-rc2-next20120821-1-iniza-generic.txt"
Content-Disposition: attachment; 
	filename="CALL-TRACE_PM-related_3.6.0-rc2-next20120821-1-iniza-generic.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h64vxw1d0

WyAyNTQ3LjA5NzU2NV0gd2xhbjA6IGRlYXV0aGVudGljYXRpbmcgZnJvbSAwMDowNDowZTplNDow
MDozZCBieSBsb2NhbCBjaG9pY2UgKHJlYXNvbj0zKQpbIDI1NDcuMTA3NTYzXSBjZmc4MDIxMTog
QWxsIGRldmljZXMgYXJlIGRpc2Nvbm5lY3RlZCwgZ29pbmcgdG8gcmVzdG9yZSByZWd1bGF0b3J5
IHNldHRpbmdzClsgMjU0Ny4xMDc1NjddIGNmZzgwMjExOiBSZXN0b3JpbmcgcmVndWxhdG9yeSBz
ZXR0aW5ncwpbIDI1NDcuMTA3NTcyXSBjZmc4MDIxMTogQ2FsbGluZyBDUkRBIHRvIHVwZGF0ZSB3
b3JsZCByZWd1bGF0b3J5IGRvbWFpbgpbIDI1NDcuMTExODA4XSBjZmc4MDIxMTogSWdub3Jpbmcg
cmVndWxhdG9yeSByZXF1ZXN0IFNldCBieSBjb3JlIHNpbmNlIHRoZSBkcml2ZXIgdXNlcyBpdHMg
b3duIGN1c3RvbSByZWd1bGF0b3J5IGRvbWFpbgpbIDI1NDcuMTExODExXSBjZmc4MDIxMTogV29y
bGQgcmVndWxhdG9yeSBkb21haW4gdXBkYXRlZDoKWyAyNTQ3LjExMTgxM10gY2ZnODAyMTE6ICAg
KHN0YXJ0X2ZyZXEgLSBlbmRfZnJlcSBAIGJhbmR3aWR0aCksIChtYXhfYW50ZW5uYV9nYWluLCBt
YXhfZWlycCkKWyAyNTQ3LjExMTgxNF0gY2ZnODAyMTE6ICAgKDI0MDIwMDAgS0h6IC0gMjQ3MjAw
MCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pClsgMjU0Ny4xMTE4MTZdIGNm
ZzgwMjExOiAgICgyNDU3MDAwIEtIeiAtIDI0ODIwMDAgS0h6IEAgMjAwMDAgS0h6KSwgKDMwMCBt
QmksIDIwMDAgbUJtKQpbIDI1NDcuMTExODE3XSBjZmc4MDIxMTogICAoMjQ3NDAwMCBLSHogLSAy
NDk0MDAwIEtIeiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKWyAyNTQ3LjExMTgx
OV0gY2ZnODAyMTE6ICAgKDUxNzAwMDAgS0h6IC0gNTI1MDAwMCBLSHogQCA0MDAwMCBLSHopLCAo
MzAwIG1CaSwgMjAwMCBtQm0pClsgMjU0Ny4xMTE4MjBdIGNmZzgwMjExOiAgICg1NzM1MDAwIEtI
eiAtIDU4MzUwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpbIDI1NDku
NTEyMTU5XSBQTTogU3luY2luZyBmaWxlc3lzdGVtcyAuLi4gZG9uZS4KWyAyNTQ5LjUxNDk1NV0g
UE06IFByZXBhcmluZyBzeXN0ZW0gZm9yIG1lbSBzbGVlcApbIDI1NDkuODY2NjMwXSBGcmVlemlu
ZyB1c2VyIHNwYWNlIHByb2Nlc3NlcyAuLi4gClsgMjU2OS44NTMxMzddIEZyZWV6aW5nIG9mIHRh
c2tzIGZhaWxlZCBhZnRlciAyMC4wMCBzZWNvbmRzICgxIHRhc2tzIHJlZnVzaW5nIHRvIGZyZWV6
ZSwgd3FfYnVzeT0wKToKWyAyNTY5Ljg1MzE1MV0gWG9yZyAgICAgICAgICAgIEQgMDAwMDAwMDAw
MDAwMDAwMCAgICAgMCAgIDc2MiAgICA3MjQgMHgwMDQwMDAwNApbIDI1NjkuODUzMTU1XSAgZmZm
Zjg4MDEwMDQ2ZmFkOCAwMDAwMDAwMDAwMDAwMDgyIDAwMDAwMDAwMDAwMjEzZGEgZmZmZmVhMDAw
MzFiZDY4MApbIDI1NjkuODUzMTU4XSAgZmZmZjg4MDExNmFiYzQ3MCBmZmZmODgwMTAwNDZmZmQ4
IGZmZmY4ODAxMDA0NmZmZDggZmZmZjg4MDEwMDQ2ZmZkOApbIDI1NjkuODUzMTYwXSAgZmZmZjg4
MDExNjQ2MTZkMCBmZmZmODgwMTE2YWJjNDcwIGZmZmY4ODAxMDA0NmZhZDggZmZmZjg4MDExZmE1
NDZlMApbIDI1NjkuODUzMTYzXSBDYWxsIFRyYWNlOgpbIDI1NjkuODUzMTcwXSAgWzxmZmZmZmZm
ZjgxMTI4NjUwPl0gPyBzbGVlcF9vbl9wYWdlKzB4MjAvMHgyMApbIDI1NjkuODUzMTczXSAgWzxm
ZmZmZmZmZjgxNjMxOTY5Pl0gc2NoZWR1bGUrMHgyOS8weDcwClsgMjU2OS44NTMxNzVdICBbPGZm
ZmZmZmZmODE2MzFhM2Y+XSBpb19zY2hlZHVsZSsweDhmLzB4ZDAKWyAyNTY5Ljg1MzE3OF0gIFs8
ZmZmZmZmZmY4MTEyODY1ZT5dIHNsZWVwX29uX3BhZ2Vfa2lsbGFibGUrMHhlLzB4NDAKWyAyNTY5
Ljg1MzE4MF0gIFs8ZmZmZmZmZmY4MTYzMDIzZj5dIF9fd2FpdF9vbl9iaXQrMHg1Zi8weDkwClsg
MjU2OS44NTMxODNdICBbPGZmZmZmZmZmODExMmFlMzA+XSB3YWl0X29uX3BhZ2VfYml0X2tpbGxh
YmxlKzB4ODAvMHg5MApbIDI1NjkuODUzMTg4XSAgWzxmZmZmZmZmZjgxMDdiODcwPl0gPyBhdXRv
cmVtb3ZlX3dha2VfZnVuY3Rpb24rMHg0MC8weDQwClsgMjU2OS44NTMxOTBdICBbPGZmZmZmZmZm
ODExMmFlZTY+XSBfX2xvY2tfcGFnZV9vcl9yZXRyeSsweGE2LzB4ZDAKWyAyNTY5Ljg1MzE5M10g
IFs8ZmZmZmZmZmY4MTEyYjJiNz5dIGZpbGVtYXBfZmF1bHQrMHgzYTcvMHg0ODAKWyAyNTY5Ljg1
MzE5N10gIFs8ZmZmZmZmZmY4MTE0Y2YzZj5dIF9fZG9fZmF1bHQrMHg2Zi8weDUwMApbIDI1Njku
ODUzMjAwXSAgWzxmZmZmZmZmZjgxMTk0ZDMwPl0gPyBfX3BvbGx3YWl0KzB4ZjAvMHhmMApbIDI1
NjkuODUzMjAzXSAgWzxmZmZmZmZmZjgxMTUwMDA3Pl0gaGFuZGxlX3B0ZV9mYXVsdCsweGY3LzB4
OWEwClsgMjU2OS44NTMyMjBdICBbPGZmZmZmZmZmYTAzMWUwNDU+XSA/IGk5MTVfZ2VtX3NldF9k
b21haW5faW9jdGwrMHhjNS8weDEwMCBbaTkxNV0KWyAyNTY5Ljg1MzIzMV0gIFs8ZmZmZmZmZmZh
MDIyZjM4Yz5dID8gZHJtX2lvY3RsKzB4NDdjLzB4NTQwIFtkcm1dClsgMjU2OS44NTMyMzRdICBb
PGZmZmZmZmZmODExNTFiMDk+XSBoYW5kbGVfbW1fZmF1bHQrMHgyNTkvMHgzNDAKWyAyNTY5Ljg1
MzIzOF0gIFs8ZmZmZmZmZmY4MTYzNjY4Mj5dIF9fZG9fcGFnZV9mYXVsdCsweDE1Mi8weDUyMApb
IDI1NjkuODUzMjQwXSAgWzxmZmZmZmZmZjgxMTkzZGY4Pl0gPyBkb192ZnNfaW9jdGwrMHg5OC8w
eDU1MApbIDI1NjkuODUzMjQzXSAgWzxmZmZmZmZmZjgxNjM2YTVlPl0gZG9fcGFnZV9mYXVsdCsw
eGUvMHgxMApbIDI1NjkuODUzMjQ1XSAgWzxmZmZmZmZmZjgxNjMzMGU1Pl0gcGFnZV9mYXVsdCsw
eDI1LzB4MzAKWyAyNTY5Ljg1MzI2M10gClsgMjU2OS44NTMyNjRdIFJlc3RhcnRpbmcgdGFza3Mg
Li4uIGRvbmUuClsgMjU2OS44NTk1ODddIHZpZGVvIExOWFZJREVPOjAwOiBSZXN0b3JpbmcgYmFj
a2xpZ2h0IHN0YXRlClsgMjU3MC42MjYyMzBdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBMMSBFbmFi
bGVkOyBEaXNhYmxpbmcgTDBTClsgMjU3MC42MzI5NjVdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBS
YWRpbyB0eXBlPTB4MS0weDItMHgwClsgMjU3MC43NDk0MzhdIElQdjY6IEFERFJDT05GKE5FVERF
Vl9VUCk6IHdsYW4wOiBsaW5rIGlzIG5vdCByZWFkeQpbIDI1NzAuOTk2NDI2XSBjZmc4MDIxMTog
Rm91bmQgbmV3IGJlYWNvbiBvbiBmcmVxdWVuY3k6IDI0NjcgTUh6IChDaCAxMikgb24gcGh5MApb
IDI1NzcuMDY3MjIwXSB3bGFuMDogYXV0aGVudGljYXRlIHdpdGggMDA6MDQ6MGU6ZTQ6MDA6M2QK
WyAyNTc3LjA3NjcxN10gd2xhbjA6IHNlbmQgYXV0aCB0byAwMDowNDowZTplNDowMDozZCAodHJ5
IDEvMykKWyAyNTc3LjA3ODYxMl0gd2xhbjA6IGF1dGhlbnRpY2F0ZWQKWyAyNTc3LjA3OTEzOV0g
aXdsd2lmaSAwMDAwOjAxOjAwLjA6IHdsYW4wOiBkaXNhYmxpbmcgSFQgYXMgV01NL1FvUyBpcyBu
b3Qgc3VwcG9ydGVkIGJ5IHRoZSBBUApbIDI1NzcuMDc5MTQ3XSBpd2x3aWZpIDAwMDA6MDE6MDAu
MDogd2xhbjA6IGRpc2FibGluZyBWSFQgYXMgV01NL1FvUyBpcyBub3Qgc3VwcG9ydGVkIGJ5IHRo
ZSBBUApbIDI1NzcuMDc5ODkxXSB3bGFuMDogYXNzb2NpYXRlIHdpdGggMDA6MDQ6MGU6ZTQ6MDA6
M2QgKHRyeSAxLzMpClsgMjU3Ny4wODM4ODddIHdsYW4wOiBSWCBBc3NvY1Jlc3AgZnJvbSAwMDow
NDowZTplNDowMDozZCAoY2FwYWI9MHg0MTEgc3RhdHVzPTAgYWlkPTIpClsgMjU3Ny4wOTA3OTZd
IHdsYW4wOiBhc3NvY2lhdGVkClsgMjU3Ny4wOTA4ODZdIElQdjY6IEFERFJDT05GKE5FVERFVl9D
SEFOR0UpOiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5Cg==
--f46d042c6b8d50904504c7c4950d--
