Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0HANJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:09:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36949 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0HANJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hPS1OWSeIe5MHMFu03+gpPinxiqwVAum4B2114QQ8q0IwF2DAa//xa+AiunCeuIZSs
         0feBnh5ldC8aQNEZnQPDZR0YvaJpAbn5O9qNEeWXtS+c547FRVPNgEdCtIzkrFBLIbTL
         6WuCqalqu2ZwGi2KYApR3u3eJzXZfcrC+ItVI=
MIME-Version: 1.0
Date: Sun, 1 Aug 2010 16:09:28 +0300
Message-ID: <AANLkTi=HP6bHiwmB36Ov9wn8HAKPc=owHjWcE0a5adRu@mail.gmail.com>
Subject: [Perf][PATCH][2.6.34.1] Include stdbool.h
From: Brian Marete <bgmarete@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00c09f89933b46dfed048cc2cbdc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00c09f89933b46dfed048cc2cbdc
Content-Type: text/plain; charset=UTF-8

Hello,

The attached patch fixes compilation of perf-events in 2.6.34.1

Thanks.

--
B. Gitonga Marete
Tel: +254-722-151-590

--00c09f89933b46dfed048cc2cbdc
Content-Type: text/x-patch; charset=US-ASCII; name="perf-stdbool.h-patch.diff"
Content-Disposition: attachment; filename="perf-stdbool.h-patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcbwql2g0

LS0tIHBlcmYuaC5vcmlnCTIwMTAtMDUtMTcgMTk6MjI6MzIuMDAwMDAwMDAwICswMzAwCisrKyBw
ZXJmLmgJMjAxMC0wOC0wMSAxNTo0Nzo0Ny4wMDAwMDAwMDAgKzAzMDAKQEAgLTczLDYgKzczLDcg
QEAKICNpbmNsdWRlIDx1bmlzdGQuaD4KICNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KICNpbmNsdWRl
IDxzeXMvc3lzY2FsbC5oPgorI2luY2x1ZGUgPHN0ZGJvb2wuaD4KIAogI2luY2x1ZGUgIi4uLy4u
L2luY2x1ZGUvbGludXgvcGVyZl9ldmVudC5oIgogI2luY2x1ZGUgInV0aWwvdHlwZXMuaCIK
--00c09f89933b46dfed048cc2cbdc--
