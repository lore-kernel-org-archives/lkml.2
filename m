Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0IVPy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:54:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:30780 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0IVPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dGZMszjBdrdzY3/V/nnWhsMEKAXHtedvTkSlyjI42iDavAc4S0sS/ABcQh4oNj+gw5
         C8dFwmXhuRmcdz6BfI+Q==
MIME-Version: 1.0
In-Reply-To: <20100917.165120.139548355.davem@davemloft.net>
References: <AANLkTimXnjnkNgwtEVpXKYMxXgmBdye=Gtjeggd4N9UA@mail.gmail.com>
	<AANLkTimRSjqewc_mC5vwdXy1t4Ax5rAf5svpOTbUEF7o@mail.gmail.com>
	<20100917.165120.139548355.davem@davemloft.net>
Date: Wed, 22 Sep 2010 10:54:54 -0500
Message-ID: <AANLkTim3V4yp+_LY8iN3R0xhV8hpPw_7o-uqwPFqXokz@mail.gmail.com>
Subject: Re: [PATCH] Move "struct net" declaration inside the __KERNEL__ macro guard
From: Ollie Wild <aaw@google.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, davem@google.com
Content-Type: multipart/mixed; boundary=000e0cd29daaa11d2c0490db2a57
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd29daaa11d2c0490db2a57
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 17, 2010 at 6:51 PM, David Miller <davem@davemloft.net> wrote:
>
> From: Ollie Wild <aaw@google.com>
> Date: Fri, 17 Sep 2010 14:38:59 -0500
>
> > (Resending with a proper signoff.)
>
> Your patch is still unusable because your email client white-space mangled
> the patch, turning tabs into space characters.
>
> Please fix this up and resubmit, thanks.

Third time's a charm ...

Signed-off-by: Ollie Wild <aaw@google.com>

--000e0cd29daaa11d2c0490db2a57
Content-Type: text/plain; charset=US-ASCII; name="netlink.txt"
Content-Disposition: attachment; filename="netlink.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_geedip340

Y29tbWl0IDI3ZmIxZWMzZmUyOTk3OGNhN2YxOTVhYWM1ZGJkYTZmMzAxYzdjMjQKQXV0aG9yOiBP
bGxpZSBXaWxkIDxhYXdAZ29vZ2xlLmNvbT4KRGF0ZTogICBGcmkgQXVnIDEzIDE0OjIxOjQ0IDIw
MTAgLTA1MDAKCiAgICBNb3ZlICJzdHJ1Y3QgbmV0IiBkZWNsYXJhdGlvbiBpbnNpZGUgdGhlIF9f
S0VSTkVMX18gbWFjcm8gZ3VhcmQuCiAgICAKICAgIFRoaXMgcGF0Y2ggcmVkdWNlcyBuYW1lc3Bh
Y2UgcG9sbHV0aW9uIGJ5IG1vdmluZyB0aGUgInN0cnVjdCBuZXQiIGRlY2xhcmF0aW9uCiAgICBv
dXQgb2YgdGhlIHVzZXJzcGFjZS1mYWNpbmcgcG9ydGlvbiBvZiBsaW51eC9uZXRsaW5rLmguICBJ
dCBoYXMgbm8gaW1wYWN0IG9uCiAgICB0aGUga2VybmVsLgogICAgCiAgICAoVGhpcyBjYW1lIHVw
IGJlY2F1c2Ugd2UgaGF2ZSBzZXZlcmFsIEMrKyBhcHBsaWNhdGlvbnMgd2hpY2ggdXNlICJuZXQi
IGFzIGEKICAgIG5hbWVzcGFjZSBuYW1lLikKICAgIAogICAgT2xsaWUKCmRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L25ldGxpbmsuaCBiL2luY2x1ZGUvbGludXgvbmV0bGluay5oCmluZGV4IDU5
ZDA2NjkuLjEyMzU2NjkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbmV0bGluay5oCisrKyBi
L2luY2x1ZGUvbGludXgvbmV0bGluay5oCkBAIC0yNyw4ICsyNyw2IEBACiAKICNkZWZpbmUgTUFY
X0xJTktTIDMyCQkKIAotc3RydWN0IG5ldDsKLQogc3RydWN0IHNvY2thZGRyX25sIHsKIAlzYV9m
YW1pbHlfdAlubF9mYW1pbHk7CS8qIEFGX05FVExJTksJKi8KIAl1bnNpZ25lZCBzaG9ydAlubF9w
YWQ7CQkvKiB6ZXJvCQkqLwpAQCAtMTUxLDYgKzE0OSw4IEBAIHN0cnVjdCBubGF0dHIgewogI2lu
Y2x1ZGUgPGxpbnV4L2NhcGFiaWxpdHkuaD4KICNpbmNsdWRlIDxsaW51eC9za2J1ZmYuaD4KIAor
c3RydWN0IG5ldDsKKwogc3RhdGljIGlubGluZSBzdHJ1Y3Qgbmxtc2doZHIgKm5sbXNnX2hkcihj
b25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogewogCXJldHVybiAoc3RydWN0IG5sbXNnaGRyICop
c2tiLT5kYXRhOwo=
--000e0cd29daaa11d2c0490db2a57--
