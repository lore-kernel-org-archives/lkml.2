Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1ALKRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:17:31 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34640 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1ALKR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=QZ6lVcB7wGSs6Y8ivTT8pSvB2jQlpXStwVvz4vayJaLsntT9z5GZzHXBzoeA95f22z
         9S6ffGZ7RtYnk49jqu3mHsocYL0zZBfwGi/DWuQhSkpoPPOBelzVnuN/2n5DLuo/9OUd
         pj0nBe+YaO6cSBsfE5wQbHaJsYh+BfB2nYQJU=
MIME-Version: 1.0
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Wed, 12 Jan 2011 12:17:07 +0200
Message-ID: <AANLkTimRM6=g+4adii9die0F+AG6D2rrb0ntczqCUKPD@mail.gmail.com>
Subject: [PATCH] sysctl: ctl_table->parent is only used for sysctl checks
To: linux-kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>, WANG Cong <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Dave Young <hidave.darkstar@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Vlad Dogaru <ddvlad@rosedu.org>
Content-Type: multipart/mixed; boundary=0016e64ca4300a1c520499a38219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64ca4300a1c520499a38219
Content-Type: text/plain; charset=UTF-8

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/sysctl.h |    2 ++
 kernel/sysctl.c        |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--0016e64ca4300a1c520499a38219
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0002-sysctl-ctl_table-parent-is-only-used-for-sysctl-chec.patch"
Content-Disposition: attachment; 
	filename="0002-sysctl-ctl_table-parent-is-only-used-for-sysctl-chec.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 21d7ad74dedf25bb_0.1

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc3lzY3RsLmggYi9pbmNsdWRlL2xpbnV4L3N5c2N0
bC5oDQppbmRleCA3YmI1Y2I2Li4wMjY2ODFmIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9z
eXNjdGwuaA0KKysrIGIvaW5jbHVkZS9saW51eC9zeXNjdGwuaA0KQEAgLTEwMTgsNyArMTAxOCw5
IEBAIHN0cnVjdCBjdGxfdGFibGUNCiAJaW50IG1heGxlbjsNCiAJbW9kZV90IG1vZGU7DQogCXN0
cnVjdCBjdGxfdGFibGUgKmNoaWxkOw0KKyNpZmRlZiBDT05GSUdfU1lTQ1RMX1NZU0NBTExfQ0hF
Q0sNCiAJc3RydWN0IGN0bF90YWJsZSAqcGFyZW50OwkvKiBBdXRvbWF0aWNhbGx5IHNldCAqLw0K
KyNlbmRpZg0KIAlwcm9jX2hhbmRsZXIgKnByb2NfaGFuZGxlcjsJLyogQ2FsbGJhY2sgZm9yIHRl
eHQgZm9ybWF0dGluZyAqLw0KIAl2b2lkICpleHRyYTE7DQogCXZvaWQgKmV4dHJhMjsNCmRpZmYg
LS1naXQgYS9rZXJuZWwvc3lzY3RsLmMgYi9rZXJuZWwvc3lzY3RsLmMNCmluZGV4IGFlNWNiYjEu
LmM1YmFkZTEgMTAwNjQ0DQotLS0gYS9rZXJuZWwvc3lzY3RsLmMNCisrKyBiL2tlcm5lbC9zeXNj
dGwuYw0KQEAgLTE3MDYsNiArMTcwNiw3IEBAIGludCBzeXNjdGxfcGVybShzdHJ1Y3QgY3RsX3Rh
YmxlX3Jvb3QgKnJvb3QsIHN0cnVjdCBjdGxfdGFibGUgKnRhYmxlLCBpbnQgb3ApDQogCXJldHVy
biB0ZXN0X3Blcm0obW9kZSwgb3ApOw0KIH0NCiANCisjaWZkZWYgQ09ORklHX1NZU0NUTF9TWVND
QUxMX0NIRUNLDQogc3RhdGljIHZvaWQgc3lzY3RsX3NldF9wYXJlbnQoc3RydWN0IGN0bF90YWJs
ZSAqcGFyZW50LCBzdHJ1Y3QgY3RsX3RhYmxlICp0YWJsZSkNCiB7DQogCWZvciAoOyB0YWJsZS0+
cHJvY25hbWU7IHRhYmxlKyspIHsNCkBAIC0xNzE0LDExICsxNzE1LDEzIEBAIHN0YXRpYyB2b2lk
IHN5c2N0bF9zZXRfcGFyZW50KHN0cnVjdCBjdGxfdGFibGUgKnBhcmVudCwgc3RydWN0IGN0bF90
YWJsZSAqdGFibGUpDQogCQkJc3lzY3RsX3NldF9wYXJlbnQodGFibGUsIHRhYmxlLT5jaGlsZCk7
DQogCX0NCiB9DQorI2VuZGlmDQorDQogDQogc3RhdGljIF9faW5pdCBpbnQgc3lzY3RsX2luaXQo
dm9pZCkNCiB7DQotCXN5c2N0bF9zZXRfcGFyZW50KE5VTEwsIHJvb3RfdGFibGUpOw0KICNpZmRl
ZiBDT05GSUdfU1lTQ1RMX1NZU0NBTExfQ0hFQ0sNCisJc3lzY3RsX3NldF9wYXJlbnQoTlVMTCwg
cm9vdF90YWJsZSk7DQogCXN5c2N0bF9jaGVja190YWJsZShjdXJyZW50LT5uc3Byb3h5LCByb290
X3RhYmxlKTsNCiAjZW5kaWYNCiAJcmV0dXJuIDA7DQpAQCAtMTg3NSw5ICsxODc4LDkgQEAgc3Ry
dWN0IGN0bF90YWJsZV9oZWFkZXIgKl9fcmVnaXN0ZXJfc3lzY3RsX3BhdGhzKA0KIAloZWFkZXIt
PnVzZWQgPSAwOw0KIAloZWFkZXItPnVucmVnaXN0ZXJpbmcgPSBOVUxMOw0KIAloZWFkZXItPnJv
b3QgPSByb290Ow0KLQlzeXNjdGxfc2V0X3BhcmVudChOVUxMLCBoZWFkZXItPmN0bF90YWJsZSk7
DQogCWhlYWRlci0+Y291bnQgPSAxOw0KICNpZmRlZiBDT05GSUdfU1lTQ1RMX1NZU0NBTExfQ0hF
Q0sNCisJc3lzY3RsX3NldF9wYXJlbnQoTlVMTCwgaGVhZGVyLT5jdGxfdGFibGUpOw0KIAlpZiAo
c3lzY3RsX2NoZWNrX3RhYmxlKG5hbWVzcGFjZXMsIGhlYWRlci0+Y3RsX3RhYmxlKSkgew0KIAkJ
a2ZyZWUoaGVhZGVyKTsNCiAJCXJldHVybiBOVUxMOw0K
--0016e64ca4300a1c520499a38219--
