Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0IMSw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:52:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab0IMSwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=B51VK8q1+O8/yWRGWM4i1GnkhXy7hQl8r1xc/zXeg2yjO+9Pv0DHVl53ZLqVWviDms
         TqffUb7zYu/W2Hu/N71OrUWmBGWdEz03AyWbs38BovZgJYCTQP77KLtPIFA0KoBwSHXI
         qf5CP2ATdyDFQfw3xCqSlTrP1wCKTq9v5PUtE=
MIME-Version: 1.0
Date: Mon, 13 Sep 2010 22:52:54 +0400
Message-ID: <AANLkTikVR1HYuuNW2ZaPHGOKqPBRJ4qz4tzBoNxeQpzi@mail.gmail.com>
Subject: Flags in linux-2.6.33.6-rc4
From: Pavel Panteleev <panteleevp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have found, that some arch-independed functions use unsigned int
(32-bits) flags instead of using unsigned long (64-bits) flags. But
struct vm_area_struct includes the field vm_flags, that is unsinged
long (64-bits). So, some archs, that use 64-bits flags, can miss some
flags. The example of such functions: do_mlock, do_mlockall,
mlock_fixup.

Best regards,
Pavel
