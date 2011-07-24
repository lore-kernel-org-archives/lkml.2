Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1GXSMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:12:16 -0400
Received: from icf.org.ru ([91.193.236.10]:56479 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab1GXSMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:12:12 -0400
X-Greylist: delayed 2916 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jul 2011 14:12:12 EDT
Date: Sun, 24 Jul 2011 21:23:34 +0400 (MSD)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: hermann <brummer-@web.de>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ANNOUNCE] 3.0-rt3
In-Reply-To: <1311525756.2276.6.camel@box>
Message-ID: <alpine.DEB.2.02.1107242118510.14833@icf.org.ru>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>  <4E2C2ED6.4040904@gmail.com>  <alpine.LFD.2.02.1107241807390.3136@ionos> <1311525756.2276.6.camel@box>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-55303083-1311528214=:14833"
X-Daemon-Classification: INNOCENT
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Jul 24 21:23:36 2011
X-DSPAM-Confidence: 0.9994
X-DSPAM-Improbability: 1 in 157552 chance of being spa
X-DSPAM-Probability: 0.0000(0)
X-DSPAM-Signature: 4e2c551820018301416213
X-DSPAM-Factors: 27,
	*From+MAILER-DAEMON, 0.00010,
	*From+#+#+Jul, 0.00011,
	*MAILER-DAEMON+#+Jul, 0.00011,
	7+4872, 0.00018,
	7+4872, 0.00018,
	h+#+#+#+h, 0.00023,
	h+#+#+#+h, 0.00023,
	the+kernel, 0.00036,
	h+#+#+h, 0.00037,
	h+#+#+h, 0.00037,
	so+I, 0.00045,
	ru+#+#+#+org, 0.00045,
	*From+#+Sun, 0.00049,
	*MAILER-DAEMON+Sun, 0.00049,
	I+just, 0.00050,
	is+#+#+#+it, 0.00054,
	With+#+Regards, 0.00055,
	I+#+#+#+it, 0.00058,
	%d0%90%d0%b9+%d0%a2%d0%b8, 0.00064,
	%d0%a2%d0%b8+%d0%a1%d0%b5%d1%80%d0%b2%d0%b8%d1%81, 0.00064,
	%d0%90%d0%b9+#+%d0%a1%d0%b5%d1%80%d0%b2%d0%b8%d1%81, 0.00064,
	I'm+#+to, 0.00065,
	%d0%9e%d0%9e%d0%9e+#+%d0%a2%d0%b8, 0.00066,
	The+#+#+#+be, 0.00066,
	IT+Service, 0.00068,
	4872+#+#+#+4872, 0.00068,
	4872+#+#+#+4872, 0.00068
X-Bounce-ID: icf.org.ru
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-55303083-1311528214=:14833
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On 2011-07-24 18:42 +0200, hermann wrote Thomas Gleixner:

Hi, I confirm it too - random freezes during normal work, no load, no logs too, sometimes 
while starting X, sometimes after X started and worked, also randome freezes 
while suspend-resume то ram aka ACPI S3 state.

h> schrieb Thomas Gleixner:
h>
h>> Dear RT Folks,
h>> 
h>> I'm pleased to announce the 3.0-rt3 release.
h>> 
h>> Changes versus 3.0-rt2:
h>> 
h>>   * Fix earlyprintk really
h>> 
h>
h>Hi
h>
h>I still have some trouble with rt1 - rt3. 
h>During boot, the kernel is absolutely silent, sometimes it hangs on boot,
h>sometimes it hangs on login, sometimes it freeze without any known reason 
h>during session (no heavy load or some thing like that).
h>I cant find any meaningful log, so I just can report it as it is here.
h>rc7-rt0 works very well here, I build 3.0-rt1 - rt3 with the same config 
h>then rt0.
h>
h>regards
h>hermann
h>
h>--
h>To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
h>the body of a message to majordomo@vger.kernel.org
h>More majordomo info at  http://vger.kernel.org/majordomo-info.html
h>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-55303083-1311528214=:14833--
