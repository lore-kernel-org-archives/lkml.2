Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0JWL0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:26:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34648 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab0JWL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=JgRVQHBfk0fryHueKwYZXtNN64aZ/7VLFvGxBvT6lCXMC4M5Bkzun77xZFC1gSM6s1
         OXAplLvIoDxmjQwZyc16nEE0WG+5W34XbyTr5dpQo38BUg/Y3HToL91VmYalb4eyJg+w
         mmfaS7FiFDaQtYzLv2dY6qNSL0jIH/vJZBpYc=
MIME-Version: 1.0
From: Piotr Piwko <piotr.piwko@embedded-engineering.pl>
Date: Sat, 23 Oct 2010 13:25:55 +0200
X-Google-Sender-Auth: SUPpGEifpnTqOqzx1e8vQQRPLNo
Message-ID: <AANLkTikAagEWRaDOKU5Khqms9By2iFgu2mWkMnqcUFqz@mail.gmail.com>
Subject: Modification of initramfs built-in to vmlinux image
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I currently work on an unconventional project which requires to make
some modifications of initramfs included in vmlinux object image. I
can successfully extract it and make the needed corrections of desired
initramfs, but I've met the problem to write it back to vmlinux image.
I try to modify the content of .init.ramfs section and relocate the
sections which are placed below. After these steps the sections map
seems to look ok, but unfortunately the new vmlinux causes a reset
during boot process.

Can I make this kind of modification on the final vmlinux object file?
Is it enough to change the content of .init.ramfs section? Maybe are
there some places or issues which I should take into consideration?

Thank you in advance for any hints or references,

-- 
Piotr Piwko
http://www.embedded-engineering.pl/
