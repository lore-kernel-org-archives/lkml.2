Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab2GIRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:24:58 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:53053 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2GIRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:24:57 -0400
Message-ID: <4FFB13E6.40904@xs4all.nl>
Date: Mon, 09 Jul 2012 19:24:54 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.4.4 r8169 weirdness
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ever since 3.4.4 I see lots more of:
Jul  9 19:08:01 box4 kernel: r8169 0000:03:00.0: eth0: link up
Jul  9 19:10:07 box4 kernel: r8169 0000:03:00.0: eth0: link up
Jul  9 19:16:44 box4 kernel: r8169 0000:03:00.0: eth0: link up
Jul  9 19:17:07 box4 kernel: r8169 0000:03:00.0: eth0: link up
Jul  9 19:17:49 box4 kernel: r8169 0000:03:00.0: eth0: link up
Jul  9 19:18:13 box4 kernel: r8169 0000:03:00.0: eth0: link up
Jul  9 19:18:43 box4 kernel: r8169 0000:03:00.0: eth0: link up
(etc, etc)

(without jigglin' the ethernet cable)

Is my hardware dying or is it the kernel?
A different ethernet switch didn't help....

Kind regards,
Udo
