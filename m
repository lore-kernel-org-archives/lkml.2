Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0EYJMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:12:34 -0400
Received: from mail.aixigo.de ([195.14.232.227]:45574 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab0EYJMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:12:32 -0400
Message-ID: <4BFB947E.9080509@aixigo.de>
Date: Tue, 25 May 2010 11:12:30 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100412 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be fully
 populated"
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Problem: At boot time I see a final message

	Waiting for /dev to be fully populated

then my laptop (Samsung P460) does a reset. The next
boot doesn't work, so I have to power-cycle the laptop.

If I boot with "acpi=off", then 2.6.34 gets stuck instead.
The last 2 lines are

	TCP reno registered
	Net: Registered protocol family 1

Any helpful comment would be highly appreciated.


Regards

Harri
