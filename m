Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3ACXTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:19:18 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42471 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3ACXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAB9v_DE1gt6O=xvSpmkfhfoWxGSXjQ+SBFBK3gPQKm2OrhCk3w@mail.gmail.com>
References: <CA+55aFxQ9vH70UrqC0ypm-diNbGcZbWbdhYa3FLH+0Vbrk4hUQ@mail.gmail.com>
 <CAB9v_DHJYAEcZDuPd3XBEib_nGca=_sKbZngV3z1N6H8KcJJGQ@mail.gmail.com>
 <CA+55aFzQtxET9JWdaLGi52OL=A9yRbj+vaa7RfniuBvfB5K04Q@mail.gmail.com>
 <6c3329$7ukf5e@orsmga002.jf.intel.com> <CAB9v_DE1gt6O=xvSpmkfhfoWxGSXjQ+SBFBK3gPQKm2OrhCk3w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Jan 2013 15:18:54 -0800
X-Google-Sender-Auth: 2VppbJuXd8yGCYZCSE_YMec-EEY
Message-ID: <CA+55aFw5hnByqQHhsOYgc14DHTejHqmWV=fW2pm4LuzF6UxwCQ@mail.gmail.com>
Subject: Re: Linux 3.8-rc2
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b5d3ef65fbc6804d26a97db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5d3ef65fbc6804d26a97db
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 3, 2013 at 3:12 PM, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
> Chris: The patch does not seem to have any effect on the problem.
>
> Peter: I've attached the dmesgs, as well as the diff between the
> interesting parts. The patch does not seem to make any difference
> there.

Alexey, what happens if you just avoid the divide-by-zero? There might
be other complications downstream, but something like the attached
patch should at least avoid doing the "divide-by-clock" when clock is
zero..

              Linus

--047d7b5d3ef65fbc6804d26a97db
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbiinfdg4

IGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3BtLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9pbnRlbF9wbS5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcG0uYwppbmRl
eCBlNmY1NGZmYWIzYmEuLmM5MzY2NzE2OTE3ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJt
L2k5MTUvaW50ZWxfcG0uYworKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9wbS5jCkBA
IC0xMDg2LDcgKzEwODYsNyBAQCBzdGF0aWMgYm9vbCBnNHhfY29tcHV0ZV93bTAoc3RydWN0IGRy
bV9kZXZpY2UgKmRldiwKIAlpbnQgZW50cmllcywgdGxiX21pc3M7CiAKIAljcnRjID0gaW50ZWxf
Z2V0X2NydGNfZm9yX3BsYW5lKGRldiwgcGxhbmUpOwotCWlmIChjcnRjLT5mYiA9PSBOVUxMIHx8
ICF0b19pbnRlbF9jcnRjKGNydGMpLT5hY3RpdmUpIHsKKwlpZiAoY3J0Yy0+ZmIgPT0gTlVMTCB8
fCAhdG9faW50ZWxfY3J0YyhjcnRjKS0+YWN0aXZlIHx8ICFjcnRjLT5tb2RlLmNsb2NrKSB7CiAJ
CSpjdXJzb3Jfd20gPSBjdXJzb3ItPmd1YXJkX3NpemU7CiAJCSpwbGFuZV93bSA9IGRpc3BsYXkt
Pmd1YXJkX3NpemU7CiAJCXJldHVybiBmYWxzZTsK
--047d7b5d3ef65fbc6804d26a97db--
