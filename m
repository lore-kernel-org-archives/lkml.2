Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1BVM3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:29:47 -0500
Received: from dd8000.kasserver.com ([85.13.132.92]:41080 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1BVM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:29:46 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 07:29:46 EST
Message-ID: <4D63A9E7.3000803@gmx.net>
Date: Tue, 22 Feb 2011 13:19:51 +0100
From: Otto Meier <gf435@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [regression]2.6.38-rc6 with XFS still does consume all free space
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
on my System a "make modules_install" with kernel 2.6.38-rc6 has eaten up
all free Space on a XFS partition.

The free Space is

/dev/sda6             56472984  43613692  12859292  78% /

after make modules_install i get

/dev/sda6             56472984  56472964        20 100% /

with kernel 2.6.37.1 everything runs fine and df shows

/dev/sda6             56472984  43262256  13210728  77% /

any idea what is going on here?

bye Otto


