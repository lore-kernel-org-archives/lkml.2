Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0KVVhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:37:02 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39154 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab0KVVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=jVvi4wKJf7QPvq/mbJ/Y/1pQHsM4tzHMEJiPilJwi2H6PNWANi92oPaKco3PX7CHGt
         5V5LmbTfNJZP4uGWFIGgYIuKFoKzjXzlwVlKpmlw7t8CDuw571ruEj5GZ1KZ5Gytgmfd
         yhbGu1u7RpTjxd5c+IjoI0mk/VQ0TiS1Q8R+s=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Nov 2010 13:36:37 -0800
Message-ID: <AANLkTimTpfQkBb=ZBE+JJ-kAi8m1WNXD=p6_2ESAh_R-@mail.gmail.com>
Subject: compat-wireless based on 2.6.37-rc3 now available
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compat-wireless, which provides a backport of the 802.11 / Bluetooth /
Ethernet drivers down to kernels >= 2.6.22 from code on 2.6.37-rc3 is
now available;

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc3-1.tar.bz2

For details on changes you can review the respective combined
ChangeLog of the kernel, compat and compat-wireless:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/ChangeLog-2.6.37-wireless

  Luis
