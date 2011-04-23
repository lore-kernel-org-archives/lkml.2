Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab1DWRAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:00:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1DWRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:00:04 -0400
Message-ID: <4DB3058F.5020400@online.de>
Date: Sat, 23 Apr 2011 18:59:59 +0200
From: Denis Washington <denisw@online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Reverse-engineer GPU fan control method on Toshiba Satellite L500?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:0Myq7Gbp6G9uMoBfGHp1bLg2kJZa0HwD9ybGsjpesdV
 6v1upRO372YbiARuUHYGg5WUSFlRAdU2IkSU+/XNDq4aLMZOI4
 vAy9YMLzp7g0qQ19baFZIeEneU7uWWZlqer6pqs0n4xQ3Xznlc
 S0AUtJD3mBXkjS9uChVW9TL3jykH4+liGjoq8bBJJniO2ETZjO
 5DxPQIdzH/h4sRGMnYR7pMFR3hr5xngoht/rXi4LUQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a Toshiba Satellite L500-164 (PSLJ3E) whose GPU fan (AMD Radeon 
HD 4650) keeps spinning loudly without slowing down when using the 
radeon driver. The propietary fglrx driver controls the fan correctly, 
though, so there must be a way to control it. However, I don't know how 
the needed information and/or operations are exposed by the laptop; 
lm-sensors detects no gpu-internal i2c thermal sensor (as would be 
supported by the radeon driver) and /sys/class/thermal shows no thermal 
zones. (Tested with today's mainline kernel.)

How can I find out how GPU fan control works on this laptop, e.g. if 
there is a Toshiba-specific ACPI interface for this? I am annoyed enough 
by this problem to do the needed reverse engineering research and at 
least help with the coding as much as I can, but I really don't know how 
to start. Any pointers would be welcome. (Please CC me when replying, as 
I am not subscribed to the lkml.)

Regards,
Denis Washington
