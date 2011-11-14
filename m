Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1KNEAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 23:00:35 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60154 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1KNEAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 23:00:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
References: <8762inleno.fsf@spindle.srvr.nix> <CAObL_7H5m_VEq-NTM1-i4ehnHwOHPq=tjai_rV0zDs0X8xGdsQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 13 Nov 2011 20:00:13 -0800
X-Google-Sender-Auth: dV44luzx6I3o_ommHzQuqF69xPE
Message-ID: <CAObL_7GEeF37rHkWYGDR3B596j8WnOJXB2dLD0ZdXgwNhU3Jkw@mail.gmail.com>
Subject: Re: [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884
 breaks the Chromium seccomp sandbox
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, mseaborn@chromium.org
Content-Type: multipart/mixed; boundary=bcaec520e5f3a376ea04b1a9e90c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec520e5f3a376ea04b1a9e90c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2011 at 6:36 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> The attached patch (in vsyscall=3Dnative mode) should help diagnose
> exactly what's wrong. =A0But I wouldn't be surprised if you can trigger
> the exact same failure on older kernels by doing

Now with actual attachment.

--Andy

--bcaec520e5f3a376ea04b1a9e90c
Content-Type: text/x-patch; charset=US-ASCII; name="log_seccomp_kill.patch"
Content-Disposition: attachment; filename="log_seccomp_kill.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_guyy31m40

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zZWNjb21wLmMgYi9rZXJuZWwvc2VjY29tcC5jCmluZGV4IDU3
ZDRiMTMuLjI5ZGVhZjggMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zZWNjb21wLmMKKysrIGIva2VybmVs
L3NlY2NvbXAuYwpAQCAtNTQsNiArNTQsNyBAQCB2b2lkIF9fc2VjdXJlX2NvbXB1dGluZyhpbnQg
dGhpc19zeXNjYWxsKQogI2lmZGVmIFNFQ0NPTVBfREVCVUcKIAlkdW1wX3N0YWNrKCk7CiAjZW5k
aWYKKwlwcmludGsoS0VSTl9FUlIgIktpbGxpbmcgJWQgZHVlIHRvIGJhZCBzZWNjb21wIHN5c2Nh
bGwgJWRcbiIsIChpbnQpY3VycmVudC0+cGlkLCAoaW50KXRoaXNfc3lzY2FsbCk7CiAJZG9fZXhp
dChTSUdLSUxMKTsKIH0KIAo=
--bcaec520e5f3a376ea04b1a9e90c--
