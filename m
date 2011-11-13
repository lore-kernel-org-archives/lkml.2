Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab1KMGdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 01:33:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1KMGdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 01:33:53 -0500
MIME-Version: 1.0
In-Reply-To: <201110281954.39191.a.miskiewicz@gmail.com>
References: <201110272327.14891.a.miskiewicz@gmail.com>
	<201110281915.09300.a.miskiewicz@gmail.com>
	<201110281954.39191.a.miskiewicz@gmail.com>
Date: Sun, 13 Nov 2011 01:33:51 -0500
X-Google-Sender-Auth: j1yk-G_bVfKeD8EV3IQSYn90hd0
Message-ID: <CAJvTdKmCgbebEOY7Ly=cE1ZV2GVG7hL5fE8LmK9nz7r8+BNPJQ@mail.gmail.com>
Subject: Re: intel_idle causing 3.0.8 system reboot (was: if nolapic not used
 then system reboots after loading first module (possibly first irq using module))
From: Len Brown <lenb@kernel.org>
To: =?ISO-8859-2?Q?Arkadiusz_Mi=B6kiewicz?= <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> intel_idle.max_cstate=2 also makes the problem go away.

Is the system running with BIOS SETUP defaults?
Are there any BIOS SETUP options related to CPU idle states?
please boot with intel_idle.max_cstate=0
and send the output of these two commands:

dmesg |grep idle
grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

thanks,
Len Brown, Intel Open Source Technology Center

>>
>> # cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 30
>> model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
>> stepping        : 5
