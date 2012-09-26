Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2IZJwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:52:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2IZJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:52:40 -0400
Message-ID: <5062D0B9.1030000@redhat.com>
Date: Wed, 26 Sep 2012 11:54:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: ACPI regression in 3.6, no more battery status, with Dell Latitude
 E6430
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all, sorry for not reporting this earlier in the cycle, but
I only got this (new) laptop yesterday ...

With both the 3.5 kernels as well as with the 3.6 kernels, there is
quite some unhappiness being reported in dmesg about the ACPI
tables, esp. surrounding BAT0. But with 3.5 I do get battery
status reported, where as with 3.6 I do not.

Here is the dmesg output of booting with 3.5.4, resp. 3.6.0-rc7:
http://people.fedoraproject.org/~jwrdegoede/dmesg-3.5
http://people.fedoraproject.org/~jwrdegoede/dmesg-3.6

Both boots were done with a standard Fedora kernel build.

Please let me know what else I can do to help. I'm a kernel developer
myself, so you can just throw a patch in my direction and I can build
a test kernels without needing any hand-holding, etc.

Regards,

Hans
