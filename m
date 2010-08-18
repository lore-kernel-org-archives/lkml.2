Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0HRTCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:02:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38978 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HRTCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=MKazophU+6OaiecDUCe5F/jwLN0uKLhVwMRjqpbRF36BaMtmiXbv3y/s0+FMlHwcpP
         iTaKKFDni8jEUrTa8MmtiGxd3OOx3SFEG7E8xPzjhn9f/VtSvyTzhWAhoqKJUKb/hjS6
         ae6NmMROZGFxCmP5zlCJ5PjRJ+lXvomeklOgE=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [REGRESSION] [SUSPEND] Opps during suspend to disk (probably also during to ram)
Date: Wed, 18 Aug 2010 21:02:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008182102.03201.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good kernel: 2.6.35
Failing kernel: 2.6.36-rc1

When I try suspend to disk under 2.6.36-rc1 ("no_console_suspend" option 
enabled) system hangs on this message:
http://unixy.pl/maciek/download/kernel/2.6.36-
rc1/zlom/suspend_issue/dsc_0001.jpg

Also during suspend to ram system hangs, but I got blank screen, so - 
unfortunately - I cannot debug this.

Config:
http://unixy.pl/maciek/download/kernel/2.6.36-
rc1/zlom/suspend_issue/config-2.6.36-rc1
dmesg:
http://unixy.pl/maciek/download/kernel/2.6.36-
rc1/zlom/suspend_issue/dmesg-2.6.36-rc1.txt
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
