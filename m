Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1GQIWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 04:22:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59085 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1GQIWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 04:22:21 -0400
MIME-Version: 1.0
Date: Sun, 17 Jul 2011 16:22:20 +0800
Message-ID: <CAM_iQpWDrhHw8-Hf4q1miHR+rT33wQb=ZSb=ffsxaSak=UHPMw@mail.gmail.com>
Subject: [Patch] include/linux/sdla.h: remove the prototype of sdla()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001517740bf6d735a504a83f942f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517740bf6d735a504a83f942f
Content-Type: text/plain; charset=UTF-8

`make headers_check` complains that

linux-2.6/usr/include/linux/sdla.h:116: userspace cannot reference
function or variable defined in the kernel

this is due to that there is no such a kernel function,

void sdla(void *cfg_info, char *dev, struct frad_conf *conf, int quiet);

I don't know why we have it in a kernel header, so remove it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

--001517740bf6d735a504a83f942f
Content-Type: text/x-patch; charset=US-ASCII; 
	name="include-linux-sdla_h-fix-headers-check-warning.diff"
Content-Disposition: attachment; 
	filename="include-linux-sdla_h-fix-headers-check-warning.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gq7qm20t0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2RsYS5oIGIvaW5jbHVkZS9saW51eC9zZGxhLmgK
aW5kZXggNTY0YWNkMy4uOTk5NWM3ZiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9zZGxhLmgK
KysrIGIvaW5jbHVkZS9saW51eC9zZGxhLmgKQEAgLTExMiwxMSArMTEyLDcgQEAgc3RydWN0IHNk
bGFfZGxjaV9jb25mIHsKICAgIHNob3J0IFRiX21heDsKIH07CiAKLSNpZm5kZWYgX19LRVJORUxf
XwotCi12b2lkIHNkbGEodm9pZCAqY2ZnX2luZm8sIGNoYXIgKmRldiwgc3RydWN0IGZyYWRfY29u
ZiAqY29uZiwgaW50IHF1aWV0KTsKLQotI2Vsc2UKKyNpZmRlZiBfX0tFUk5FTF9fCiAKIC8qIGlt
cG9ydGFudCBaODAgd2luZG93IGFkZHJlc3NlcyAqLwogI2RlZmluZSBTRExBX0NPTlRST0xfV05E
CQkweEUwMDAK
--001517740bf6d735a504a83f942f--
