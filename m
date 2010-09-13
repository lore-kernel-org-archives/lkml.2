Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0IMI0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:26:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54076 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0IMI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:26:02 -0400
Message-ID: <4C8DE00F.7070801@canonical.com>
Date: Mon, 13 Sep 2010 16:25:51 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100903 Thunderbird/3.1.3
MIME-Version: 1.0
To: linux-pm@lists.linux-foundation.org
CC: Len Brown <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: intel_idle
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I test myself which says when CONFIG_CPU_IDLE=y, Lenovo ideapad S10-3 can
not boot. The CPU is Atom N450, and I also find the report[2] that says intel_idle
works fine with N450.

I do not have much knowledge about intel_idle. is there any similar report that on
some machine intel_idle halt the system or any suggestion for next step debug?


[1] http://launchpad.net/bugs/634702
[2] http://www.spinics.net/lists/linux-pm/msg21334.html
