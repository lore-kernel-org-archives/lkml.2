Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160Ab2LFPa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:30:59 -0500
Received: from nm29-vm5.bullet.mail.gq1.yahoo.com ([98.136.216.180]:41555 "EHLO
	nm29-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965094Ab2LFPa6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:30:58 -0500
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 10:30:58 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 174828.60011.bm@omp1013.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VLJviqexvzEB4dolsHCQlTKwhTphp1XiQPZDcsPEhCopJzt39EPTZBf1prf4gr/LT9tItEhoscltI+3BcSSmXyUQ8CFDPi7Llb5E7uggRk5XwYg1eVDO8Q0VKkRzPBlLEkzjC1Hoo3ABQO/04EebT755motbNHxnqrki4OGRDow=;
X-YMail-OSG: dTm5IpYVM1nOvCBhXuLeuc4Z52elPlQ4MDNG0SdbmgIiHa6
 fK77ExGtM78GDpThwvpc83coNBm71LLOFaJlnH51xYUwx3Xr5E_b18RKa0kl
 fhCfDNx8tb1v8h12ypJ_JoYWeFINtEnjbOPLPi.BeNavRNMykOvirrsTsXdN
 no6XPoQMYET3jL4eRMVZKTaawQvLjYqmvIrgp0uIE8a.eHOEdnw2Bsb0edk7
 7n.V3BuO6dOcWZXwPKAox9bV1Ev5BS14npZfn1L_suwz0UtzgyB0Gy40qhPC
 OlILOlqEuWdFUNSS0MTMEwBn9eYSuOPLpVYKA4ayshYCOq.sa5kkayPHvVmw
 hrxJC4ICEhxFjc4s_DD_ifGNpas2sv5mDFWZ70CaiB272JcyQ.gdSNpsZ1Ex
 I4_ECW8jou3P4qBe069p7Kn4x4IUJJB3Fkz4WbYqEuUvrgx4Zt2Qd.AQ6YOQ
 BS9O6y4QnxtXRKHAWk7jyVaaDFT6AsTu5KQumdtnfd2y.V0hpFd2TPVyn5op
 MtYWekg--
X-Rocket-MIMEInfo: 001.001,SGVsbG8sIGR1cmluZyByZW1vdGUgY29tcGlsYXRpb24gbmV0d29yayBodW5nLCB0aGVuIGFmdGVyIHJlbG9naW4gY29tcGlsbGVkIGFnYWluIHdpdGggc3VjY2VzcywgYnV0wqAgZm91bmQgcHJvY2VzcyAiYXMiIHN0aWxsIHdvcmtpbmcgYXQgMTAwJSwgYW5kIGl0IHdhcyBpbXBvc3NpYmxlIHRvIGtpbGwgaXQgZXZlbiB3aXRoICItOSIuIFRoZW4gYWZ0ZXIgcmVib290aW5nIHRoZSBzeXN0ZW0gaSB0b29rIGEgbG9vayBhdCBzeXNsb2cgYW5kIGZvdW5kIHRoaXMgb29wczoKCkRlY8KgIDYgMTc6MTI6NDcgYyABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.128.478
Message-ID: <1354807062.89073.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Thu, 6 Dec 2012 07:17:42 -0800 (PST)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: kill -9 doesn't help 
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, during remote compilation network hung, then after relogin compilled again with success, but  found process "as" still working at 100%, and it was impossible to kill it even with "-9". Then after rebooting the system i took a look at syslog and found this oops:

Dec  6 17:12:47 c kernel: [5745980.766010] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 3, t=60002 jiffies)
Dec  6 17:12:47 c kernel: [5745980.766022] Pid: 0, comm: swapper/3 Tainted: G         C   3.2.29 #1
Dec  6 17:12:47 c kernel: [5745980.766026] Call Trace:
Dec  6 17:12:47 c kernel: [5745980.766029]  <IRQ>  [<ffffffff8109a408>] __rcu_pending+0x3e8/0x3f0
Dec  6 17:12:47 c kernel: [5745980.766044]  [<ffffffff8109ad91>] rcu_check_callbacks+0x61/0x110
Dec  6 17:12:47 c kernel: [5745980.766051]  [<ffffffff810540d3>] update_process_times+0x43/0x80
Dec  6 17:12:47 c kernel: [5745980.766057]  [<ffffffff810723c1>] tick_sched_timer+0x61/0xb0
Dec  6 17:12:47 c kernel: [5745980.766063]  [<ffffffff81066339>] __run_hrtimer.isra.31+0x49/0xd0
Dec  6 17:12:47 c kernel: [5745980.766068]  [<ffffffff81066b05>] hrtimer_interrupt+0xe5/0x210
Dec  6 17:12:47 c kernel: [5745980.766074]  [<ffffffff8101bed4>] smp_apic_timer_interrupt+0x64/0xa0
Dec  6 17:12:47 c kernel: [5745980.766081]  [<ffffffff815128cb>] apic_timer_interrupt+0x6b/0x70
Dec  6 17:12:47 c kernel: [5745980.766084]  <EOI>  [<ffffffff8103c17e>] ? pick_next_task_fair+0x6e/0x180
Dec  6 17:12:47 c kernel: [5745980.766096]  [<ffffffff812fd55e>] ? acpi_idle_enter_simple+0xbf/0xfc
Dec  6 17:12:47 c kernel: [5745980.766101]  [<ffffffff812fd559>] ? acpi_idle_enter_simple+0xba/0xfc
Dec  6 17:12:47 c kernel: [5745980.766108]  [<ffffffff8141b957>] cpuidle_idle_call+0x97/0x100
Dec  6 17:12:47 c kernel: [5745980.766113]  [<ffffffff81000955>] cpu_idle+0xa5/0x110
Dec  6 17:12:47 c kernel: [5745980.766118]  [<ffffffff815013c4>] start_secondary+0x1cf/0x1d6
Dec  6 17:15:47 c kernel: [5746160.798011] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 3, t=240034 jiffies)
Dec  6 17:15:47 c kernel: [5746160.798022] Pid: 0, comm: swapper/3 Tainted: G         C   3.2.29 #1
Dec  6 17:15:47 c kernel: [5746160.798026] Call Trace:
Dec  6 17:15:47 c kernel: [5746160.798029]  <IRQ>  [<ffffffff8109a408>] __rcu_pending+0x3Dec  6 17:19:24 c kernel: [    0.000000] ACPI: RSDP 00000000000f6b80 00014 (v00 GBT   )


The time of the oops is just before rebooting.

It is Slackware with kernel config: http://pastebin.com/HrWPQegM

Regards:
Adko.

