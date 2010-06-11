Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0FKPLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:11:13 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:37967 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752089Ab0FKPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:11:12 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2010 11:11:11 EDT
X-DYX-POP3-Checked-Auth: 114.32.100.136:kernel@takeo.idv.tw
Message-ID: <96E6C0BE64964D189082401226E76E53@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: <linux-kernel@vger.kernel.org>
Subject: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: Permission denied
Date: Fri, 11 Jun 2010 23:04:30 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I using linux-next-20100608 kernel, but if re-complier the kernel will found 
this messages.

root@kernel-x86:/usr/src/linux# make oldconfig
  HOSTCC  scripts/basic/fixdep
/bin/sh: scripts/basic/fixdep: Permission denied
make[1]: *** [scripts/basic/fixdep] Error 1
make: *** [scripts_basic] Error 2

But if I revert this patch, seems all back to normal, pls help me this is 
bug patch or need adjust some system config?

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=9d9b938248736826e86db9b16a3b435bdb5d649f

Thanks,
Takeo Tung 

