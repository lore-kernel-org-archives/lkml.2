Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1JQBdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:33:52 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:37011 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751341Ab1JQBdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:33:51 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: 3.1-rc9 wifi problem
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dave.taht@gmail.com, rientjes@google.com, arend@broadcom.com,
        toralf.foerster@gmx.de, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        larry.finger@gmail.com
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sun, 16 Oct 2011 21:33:46 -0400
Message-ID: <web-627302724@zbackend1.aha.ru>
In-Reply-To: <4E9A4496.1000906@lwfinger.net>
References: <web-626905859@zbackend1.aha.ru>
 <4E9A4496.1000906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to wait until the friend with the laptop comes 
back, perhaps this week. Then I can look what wireless 
card is in it.

However, now I remember me:  that laptop worked only good 
since 2.6.39 with the new kernel-embedded modules. 
  Before, it didn't work normally, i.e. on booting the 
wireless almost never didn't switch on; only ocasionally .


And, beside of kernel 2.6.39, and the normal wifi 
software, I still had him to install a file 
iwlwifi-1000-3.ucode or .5 ucode (i'm not sure, the number 
can also be 5000), and I had the problem to search long 
time for that file because one find only .2 or .4 in 
internet but what don't work at that wifi card.   You 
could improve the kernel-module so that everything is 
included so that one don't need to search such files.

Then, with this kernel and that file however, it worked 
without any problem.

I hope from these informations you can find out what wifi 
card or what driver is in the laptop.

W.Landgraf
---
Professional hosting for everyone - http://www.host.ru
