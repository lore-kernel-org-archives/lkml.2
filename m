Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0EXLKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:10:34 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:33872 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0EXLKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:10:33 -0400
X-Greylist: delayed 3042 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 07:10:32 EDT
Message-ID: <4BFA52C3.4080006@xs4all.nl>
Date: Mon, 24 May 2010 12:19:47 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: hpet timers gone?
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What has happened between 2.6.30.9 and 2.6.32.8 with regard to hpet timers?

dmesg output from 2.6.30.9 does show activity but 2.6.32.8 and beyond don't.
Also /proc/timer_list doesn't show hpet anymore. Also on 2.6.34 no hpet
in timer_list.

relevant .config:
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y

And I have hpet=force on the kernel commandline for this VIA Epia
LT10000 board.

Any ideas?

Kind regards,
Udo

