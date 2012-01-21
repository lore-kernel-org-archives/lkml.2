Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2AUHU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 02:20:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2AUHU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 02:20:26 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 20 Jan 2012 23:20:01 -0800
X-Google-Sender-Auth: 5cya8DtNMeExWxYW4A5djp6Sa88
Message-ID: <CAB=NE6XgZXao7avh85RW9gn3NzA1ZP5wVrgzTEzfJBiJkSnonQ@mail.gmail.com>
Subject: compat-wireless based on v3.3-rc1
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus released v3.3-rc1 yesterday, the respective backport of the
wireless, bluetooth and ethernet drivers for that release for older
kernels is now available for testing [0]. For details refer to the
Changelog [1] and site [2]. I've only compile tested this against
2.6.38.

[0] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.3/compat-wireless-3.3-rc1-2.tar.bz2
[1] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.3/ChangeLog-3.3-wireless
[2] http://wireless.kernel.org/en/users/Download/stable/

  Luis
