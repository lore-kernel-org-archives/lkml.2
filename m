Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1ALKPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:15:03 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33028 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1ALKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=QT7/wq1MfIXVVpFJRSLNdJSNfwdhRsW6DckzyH9WG6jAGQTI29Ns5cI51RqBTKc/yz
         lMm8NKHf+8cV09Ak8wdSR9WnTJICwGFjfei8nYYnMDwvMpQYO7AkKTP4z9nwfb1gFjOm
         Xppz/oZzI8qf4YDQRYns5ns1EV7UeuKbx/5tM=
MIME-Version: 1.0
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Wed, 12 Jan 2011 12:14:40 +0200
Message-ID: <AANLkTikQMrE4eiyEq8fNb2taM+VFN3_fqkrpfYADfcCg@mail.gmail.com>
Subject: [PATCH] proc: proc_inode pid/fd and sysctl/sysctl_entry are never
 used at the same time
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Vlad Dogaru <ddvlad@rosedu.org>,
        Octavian Purdila <opurdila@ixiacom.com>
Content-Type: multipart/mixed; boundary=00163683204e4bf2a50499a37943
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163683204e4bf2a50499a37943
Content-Type: text/plain; charset=UTF-8

Or at least I could not find a place where both are
used at the same time.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/proc_fs.h |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

--00163683204e4bf2a50499a37943
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-proc-proc_inode-pid-fd-and-sysctl-sysctl_entry-are-n.patch"
Content-Disposition: attachment; 
	filename="0001-proc-proc_inode-pid-fd-and-sysctl-sysctl_entry-are-n.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 91ef98928cb85818_0.1

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcHJvY19mcy5oIGIvaW5jbHVkZS9saW51eC9wcm9j
X2ZzLmgNCmluZGV4IDM3OWVhZWQuLjNjMjg3ZTMgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4
L3Byb2NfZnMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9wcm9jX2ZzLmgNCkBAIC0yNjIsMTIgKzI2
MiwxOCBAQCBzdHJ1Y3QgY3RsX3RhYmxlX2hlYWRlcjsNCiBzdHJ1Y3QgY3RsX3RhYmxlOw0KIA0K
IHN0cnVjdCBwcm9jX2lub2RlIHsNCi0Jc3RydWN0IHBpZCAqcGlkOw0KLQlpbnQgZmQ7DQotCXVu
aW9uIHByb2Nfb3Agb3A7DQorCXVuaW9uIHsNCisJCXN0cnVjdCB7DQorCQkJaW50IGZkOw0KKwkJ
CXN0cnVjdCBwaWQgKnBpZDsNCisJCX07DQorCQlzdHJ1Y3Qgew0KKwkJCXN0cnVjdCBjdGxfdGFi
bGVfaGVhZGVyICpzeXNjdGw7DQorCQkJc3RydWN0IGN0bF90YWJsZSAqc3lzY3RsX2VudHJ5Ow0K
KwkJfTsNCisJfTsNCiAJc3RydWN0IHByb2NfZGlyX2VudHJ5ICpwZGU7DQotCXN0cnVjdCBjdGxf
dGFibGVfaGVhZGVyICpzeXNjdGw7DQotCXN0cnVjdCBjdGxfdGFibGUgKnN5c2N0bF9lbnRyeTsN
CisJdW5pb24gcHJvY19vcCBvcDsNCiAJc3RydWN0IGlub2RlIHZmc19pbm9kZTsNCiB9Ow0KIA0K
--00163683204e4bf2a50499a37943--
