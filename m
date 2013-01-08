Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3AHX4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:56:19 -0500
Received: from norkia.v3.sk ([91.210.183.14]:53023 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab3AHX4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:56:16 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        libertas-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, linux-kernel@vger.kernel.org,
        lkundrak@v3.sk
Subject: sd8688 firmware location
Date: Wed,  9 Jan 2013 00:56:00 +0100
Message-Id: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

btmrvl_sdio and libertas_sdio both use firmware files sd8688.bin and
sd8688_helper.bin. In linux-firmware, they're present in libertas/ tree and
(since 3d32a58b) libertas_sdio perfers loading it from there, while it is able
to fallback to load it from linux-firmware root. btmrvl_sdio, on the other hand
only looks in the root and ends up not being successful.

Obviously, there are two solutions to the problem -- either teach btmrvl_sdio
to look into libertas/, or move the files in linux-firmware tree. I don't
really have a strong preference, though it probably makes less sense to keep in
in libertas/, since the bluetooth hardware is not really marketed as "Libertas."

I'm following up with patches to linux and linux-firmware and I'd be very
thankful if you could pick one (not both of them).

Have a nice day!
--
Lubomir Rintel       >o
                      (\)

