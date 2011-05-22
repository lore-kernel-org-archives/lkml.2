Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1EVOnC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:43:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47505 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1EVOm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=W8AKkGSO4qr92QvGSBnmnL2L1EJr8f3PbhsSWOq8ZgrU40zgu+6b9V0xY6QMqrGYPk
         t+EGZDksqvA815ga0FxUsc/KHST/gZ9x9WLmNk9gPGeU6dNLXyIFKMju/GP1zfWUe+p6
         Pnm7E63vzz1MvW0yvDxQfRX/VSHZ1GdBxYfaA=
MIME-Version: 1.0
Date: Sun, 22 May 2011 22:42:56 +0800
Message-ID: <BANLkTimdog_wi+7_Vx7Qzpc0ZYor_RHg2g@mail.gmail.com>
Subject: [Patch] cris: add missing declaration of kgdb_init() and breakpoint()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: multipart/mixed; boundary=000325576392dd9d7b04a3de5e22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000325576392dd9d7b04a3de5e22
Content-Type: text/plain; charset=UTF-8

This patch fixes such a build error on cris:

arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration of
function 'kgdb_init'
arch/cris/arch-v10/kernel/irq.c:240: error: implicit declaration of
function 'breakpoint'

So, just declare these two functions.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>

---

--000325576392dd9d7b04a3de5e22
Content-Type: text/x-patch; charset=US-ASCII; name="cris-fix-build-error-kgdb_init.diff"
Content-Disposition: attachment; 
	filename="cris-fix-build-error-kgdb_init.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go03ikfv1

ZGlmZiAtLWdpdCBhL2FyY2gvY3Jpcy9hcmNoLXYxMC9rZXJuZWwvaXJxLmMgYi9hcmNoL2NyaXMv
YXJjaC12MTAva2VybmVsL2lycS5jCmluZGV4IDkwN2NmYjUuLmJhMGU1OTYgMTAwNjQ0Ci0tLSBh
L2FyY2gvY3Jpcy9hcmNoLXYxMC9rZXJuZWwvaXJxLmMKKysrIGIvYXJjaC9jcmlzL2FyY2gtdjEw
L2tlcm5lbC9pcnEuYwpAQCAtMjAsNiArMjAsOSBAQAogI2RlZmluZSBjcmlzdjEwX21hc2tfaXJx
KGlycV9ucikgKCpSX1ZFQ1RfTUFTS19DTFIgPSAxIDw8IChpcnFfbnIpKTsKICNkZWZpbmUgY3Jp
c3YxMF91bm1hc2tfaXJxKGlycV9ucikgKCpSX1ZFQ1RfTUFTS19TRVQgPSAxIDw8IChpcnFfbnIp
KTsKIAorZXh0ZXJuIHZvaWQga2dkYl9pbml0KHZvaWQpOworZXh0ZXJuIHZvaWQgYnJlYWtwb2lu
dCh2b2lkKTsKKwogLyogZG9uJ3QgdXNlIHNldF9pbnRfdmVjdG9yLCBpdCBieXBhc3NlcyB0aGUg
bGludXggaW50ZXJydXB0IGhhbmRsZXJzLiBpdCBpcwogICogZ2xvYmFsIGp1c3Qgc28gdGhhdCB0
aGUga2VybmVsIGdkYiBjYW4gdXNlIGl0LgogICovCg==
--000325576392dd9d7b04a3de5e22--
