Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1CWPa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:30:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933135Ab1CWPaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie> <AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Mar 2011 08:29:35 -0700
Message-ID: <AANLkTi=zcXFOGj+pi1YSVY1kHoULEAQRNrnzmw2Pexns@mail.gmail.com>
Subject: Re: [git pull] drm next tree
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00151773e34074002b049f2808a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151773e34074002b049f2808a7
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Mar 22, 2011 at 7:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Keith/Jesse/Chris - I don't know that it's i915, and it will take
> forever to bisect (I'll try). But it does seem pretty likely.

Ok, so I'm still bisecting, but it's definitely the DRM pull. Current
bisection log attached (the result does contain the fbdev pull from
Paul Mundt, but that doesn't touch any files I compile afaik).

                       Linus

--00151773e34074002b049f2808a7
Content-Type: application/octet-stream; name=BISECT_LOG
Content-Disposition: attachment; filename=BISECT_LOG
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glmeqgaw1

Z2l0IGJpc2VjdCBzdGFydAojIGJhZDogWzY0NDdmNTVkYTkwYjc3ZmFlYzE2OTdkNDk5ZWQ3OTg2
YmI0ZjZkZTZdIE1lcmdlIGJyYW5jaCAnbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2RqYncvYXN5bmNfdHgKZ2l0IGJpc2VjdCBiYWQgNjQ0N2Y1
NWRhOTBiNzdmYWVjMTY5N2Q0OTllZDc5ODZiYjRmNmRlNgojIGdvb2Q6IFs1MjFjYjQwYjBjNDQ0
MThhNGZkMzZkYzYzM2Y1NzU4MTNkNTlhNDNkXSBMaW51eCAyLjYuMzgKZ2l0IGJpc2VjdCBnb29k
IDUyMWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0M2QKIyBnb29kOiBbN2E2MzYy
ODAwY2I3ZDFkNjE4YTY5N2E2NTBjN2FhZWQzZWIzOTMyMF0gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldC1uZXh0LTIuNgpnaXQgYmlz
ZWN0IGdvb2QgN2E2MzYyODAwY2I3ZDFkNjE4YTY5N2E2NTBjN2FhZWQzZWIzOTMyMAojIGJhZDog
WzBkZjA5MTRkNDE0YTUwNGI5NzVmM2NjNjZhY2UwYzE2ZWY1NWI3ZjNdIE1lcmdlIGJyYW5jaCAn
b21hcC1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90bWxpbmQvbGludXgtb21hcC0yLjYKZ2l0IGJpc2VjdCBiYWQgMGRmMDkxNGQ0MTRh
NTA0Yjk3NWYzY2M2NmFjZTBjMTZlZjU1YjdmMwojIGJhZDogW2M1NWQyNjdkZTI3NGQzMDg5Mjdi
NjBjM2U3NDBjMWE4MjY4MzIzMTddIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9qZWpiL3Njc2ktbWlzYy0yLjYKZ2l0IGJpc2VjdCBiYWQgYzU1ZDI2
N2RlMjc0ZDMwODkyN2I2MGMzZTc0MGMxYTgyNjgzMjMxNwojIGJhZDogW2ZkMzRiMGRlZTRkMjM3
Y2U5MzMyY2M2MmIwM2FkZWJmZTRmYTlmOWRdIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9sZXRoYWwvZmJkZXYtMi42CmdpdCBiaXNlY3QgYmFkIGZk
MzRiMGRlZTRkMjM3Y2U5MzMyY2M2MmIwM2FkZWJmZTRmYTlmOWQKIyBnb29kOiBbYjA0ZDBhOTA5
MDhjZGI3MzNlNDkwNDg2Mjg3ZTFiYThjNTY4ZmZiMF0gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL3NwYXJjLW5leHQtMi42CmdpdCBiaXNl
Y3QgZ29vZCBiMDRkMGE5MDkwOGNkYjczM2U0OTA0ODYyODdlMWJhOGM1NjhmZmIwCiMgZ29vZDog
W2JiOWIxOGEzOTBkYjRhMTVjZDQ2YmJkNzQ3MjUxMGZlYjdkNGMxNjhdIGRybS9ub3V2ZWF1OiBh
ZGQgbm91dmVhdV9lbnVtX2ZpbmQoKSB1dGlsIGZ1bmN0aW9uCmdpdCBiaXNlY3QgZ29vZCBiYjli
MThhMzkwZGI0YTE1Y2Q0NmJiZDc0NzI1MTBmZWI3ZDRjMTY4Cg==
--00151773e34074002b049f2808a7--
