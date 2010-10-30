Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0J3Jfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:35:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53208 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0J3Jfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=Ygyy/lbotoHuWf/QBn+QuqyLXnYHJe9CvJmWRGqudCqyAo5GtdCGp+dn0n8ZUJBlYg
         X+SirIF7hFQXDmC4fB/cyDOyHKUKb9LOmP5Q9alr93PCRPCfvYg9pqtcWrwI4+sp+pOi
         ds5WxdNfHYOsfSEa2vkvreD+Li1s5Z8o/znOQ=
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 30 Oct 2010 11:35:22 +0200
X-Google-Sender-Auth: U53T_RDYRr4UrUlos4mjk5BtllM
Message-ID: <AANLkTi=sR+wTN1MSRZLW1qB99ybGgOTbUJuw8drtbwA5@mail.gmail.com>
Subject: New 2.6.36 checkpatch complaints about leading whitespace
To: Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Vladislav Bolkhovitin <vst@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

Apparently the checkpatch.pl script as included in 2.6.36 complains if
continued lines start with whitespace. An example:

[ ... ]
+#if defined(MACRO_NAME_1) || defined(MACRO_NAME_2) \
+  || defined(MACRO_NAME_3)
[ ... ]

checkpatch.pl reports the following warning for the above patch excerpt:

WARNING: please, no space for starting a line,
                                excluding comments

Is that a feature or an unintended side effect of recent checkpatch changes ?

Bart.
