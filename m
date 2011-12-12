Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1LLFTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:19:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63505 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1LLFTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:19:21 -0500
Message-ID: <4EE58ED5.108@gmail.com>
Date: Sun, 11 Dec 2011 22:19:17 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: skeggsb@gmail.com
CC: Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DRM nouveau crash with 3.2.0-rc5
References: <4EE2E9BB.8060801@gmail.com>		<CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com>	 <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com>	 <4EE42ADA.5000406@gmail.com> <1323590203.31951.2.camel@nisroch>
In-Reply-To: <1323590203.31951.2.camel@nisroch>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------090300010301090400060204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090300010301090400060204
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/2011 12:56 AM, Ben Skeggs wrote:
> On Sat, 2011-12-10 at 21:00 -0700, Berck E. Nash wrote:
>> On 12/10/2011 08:54 PM, Ben Skeggs wrote:
>>> Is this reproducible in any way, or a once off occurance?

And on the off chance it helps, here's crash3.  Substantially smaller,
maybe easier to track down?

--------------090300010301090400060204
Content-Type: text/plain;
 name="drm-crash3.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="drm-crash3.log"

WyAzMzQ5LjE2MDAxM10gW2RybV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAtIFRS
QVBfVkZFVENIIEZBVUxUClsgMzM0OS4xNjY2MDZdIFtkcm1dIG5vdXZlYXUgMDAwMDowMTow
MC4wOiBQR1JBUEggLSBUUkFQX1ZGRVRDSCAwMGYwMDAwMCAwMDAwZmUwYyAwMDAwMDAwMCAw
MDAwMDAwMApbIDMzNDkuMTc1OTc4XSBbZHJtXSBub3V2ZWF1IDAwMDA6MDE6MDAuMDogUEdS
QVBIIC0gVFJBUApbIDMzNDkuMTgxMjE3XSBbZHJtXSBub3V2ZWF1IDAwMDA6MDE6MDAuMDog
UEdSQVBIIC0gY2ggNSAoMHgwMDBjMmQzMDAwKSBzdWJjIDUgY2xhc3MgMHg4Mjk3IG10aGQg
MHgwZjA0IGRhdGEgMHgwMDAwMDAwMApbIDMzNDkuMTkyMDg0XSBbZHJtXSBub3V2ZWF1IDAw
MDA6MDE6MDAuMDogVk06IHRyYXBwZWQgcmVhZCBhdCAweDAwMDAwMDAwMDAgb24gY2ggMiBb
MHgwMDAwMGQwM10gUEdSQVBIL1ZGRVRDSC8wMCByZWFzb246IFBUX05PVF9QUkVTRU5UClsg
NTc2NC43NTEzODldIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4wOiBQRklGT19ETUFfUFVT
SEVSIC0gQ2ggMiBHZXQgMHgwMDIwMDI3M2YwIFB1dCAweDAwMjAwMjc0M2MgSWJHZXQgMHgw
MDAwMDA3MSBJYlB1dCAweDAwMDAwMDdlIFN0YXRlIDB4ODAwMDQyOTAgKGVycjogSU5WQUxJ
RF9DTUQpIFB1c2ggMHgwMDQwNjA0MApbIDU3NjQuNzY4MzI1XSBbZHJtXSBub3V2ZWF1IDAw
MDA6MDE6MDAuMDogUEdSQVBIIC0gREFUQV9FUlJPUiBJTlZBTElEX1ZBTFVFClsgNTc2NC43
NzUzNjBdIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4wOiBQR1JBUEggLSBEQVRBX0VSUk9S
ClsgNTc2NC43ODExNjldIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4wOiBQR1JBUEggLSBj
aCAyICgweDAwMDBkMDMwMDApIHN1YmMgMiBjbGFzcyAweDUwMmQgbXRoZCAweDAyODggZGF0
YSAweDAwMGNiNTc0ClsgNjgwOC4xNjU4MzhdIFtkcm1dIG5vdXZlYXUgMDAwMDowMTowMC4w
OiBQR1JBUEggLSBEQVRBX0VSUk9SIElOVkFMSURfVkFMVUUKWyA2ODA4LjE3MjY3Ml0gW2Ry
bV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAtIERBVEFfRVJST1IKWyA2ODA4LjE3
ODMwOF0gW2RybV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAtIGNoIDIgKDB4MDAw
MGQwMzAwMCkgc3ViYyAyIGNsYXNzIDB4NTAyZCBtdGhkIDB4MDI4NCBkYXRhIDB4MDAwNGFm
MDAKWzEwOTM4LjM2MDg1NF0gW2RybV0gbm91dmVhdSAwMDAwOjAxOjAwLjA6IFBHUkFQSCAt
IERBVEFfRVJST1IgSU5WQUxJRF9WQUxVRQpbMTA5MzguMzY3OTQ3XSBbZHJtXSBub3V2ZWF1
IDAwMDA6MDE6MDAuMDogUEdSQVBIIC0gREFUQV9FUlJPUgpbMTA5MzguMzczNzQwXSBbZHJt
XSBub3V2ZWF1IDAwMDA6MDE6MDAuMDogUEdSQVBIIC0gY2ggMiAoMHgwMDAwZDAzMDAwKSBz
dWJjIDIgY2xhc3MgMHg1MDJkIG10aGQgMHgwMjhjIGRhdGEgMHgyMDAzMTAwMAo=
--------------090300010301090400060204--
