Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1LYSge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 13:36:34 -0500
Received: from smtprelay0007.b.hostedemail.com ([64.98.42.7]:38083 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752824Ab1LYSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 13:36:31 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1459
Date: Sun, 25 Dec 2011 18:36:29 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Cc: davej@redhat.com, cpufreq@vger.kernel.org
Message-ID: <388674780.142932.1324838189780.JavaMail.mail@webmail18>
References: <1982761334.142905.1324837801755.JavaMail.mail@webmail18>
Subject: cpufreq userspace governor doesn't work for Intel Core 2 Gen 2 CPUs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.147.5.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my Intel Core i5 CPU with acpi-cpufreq module loaded I do this

# echo 2000000 | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_setspeed

then

# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq
2000000
2000000
2000000
2000000

so theoretically it should work.

However i7z (http://code.google.com/p/i7z/) shows that CPU frequency is freely floating
and turbo boost gets enabled as soon as I have any discernible load, in other words 
userspace CPU frequency driver doesn't work at all and it doesn't really enforce the specified
CPU frequency.

Best wishes,

Artem
