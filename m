Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1DBXsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 19:48:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61172 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab1DBXsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 19:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=fgtES1F+aqZ/5Xd2WxQOrkPza6EUz4PCu+6CIMboUidSjmaENIont+lZXrknEwfLyY
         QhI9rVDwuj007I2gcJx4+AJJnVPyKvJS7MyinmBi5eYjGVoJvI8OJoM0mpl7JP67UGrj
         he4xjAKkIqDm/ovj43ItmNdWh6lCUxgTyGkcs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
Date: Sat, 2 Apr 2011 18:48:12 -0500
Message-ID: <AANLkTin9TY5t6TM3pY2_UOg56y6ChDkd8EyJ6eUghQ5X@mail.gmail.com>
Subject: [PATCH] Fixes a small error in Documentation/HOWTO
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm think I might be sending this for the second time, if you can see
this, can you reply to it?)

Description: This patch fixes a small error in Documentation/HOWTO
which gives a really old link for LXR.

This will be my first patch, so, any feedback is very welcome The
Patch follows this line. I'm not sure if I'm supposed to include the
HOWTO.orig stuff.


--- linux-2.6.38.2/Documentation/HOWTO.orig     2011-04-02
15:55:03.000000000 -0400
+++ linux-2.6.38.2/Documentation/HOWTO  2011-04-02 15:56:25.000000000 -0400
@@ -209,8 +209,7 @@ tools.  One such tool that is particular
 Cross-Reference project, which is able to present source code in a
 self-referential, indexed webpage format. An excellent up-to-date
 repository of the kernel code may be found at:
-       http://users.sosdg.org/~qiyong/lxr/
-
+       http://lxr.linux.no/linux+v2.6.38/Documentation/

 The development process
 -----------------------
