Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1GTLb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 07:31:27 -0400
Received: from mail001.aei.ca ([206.123.6.130]:39278 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1GTLb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 07:31:26 -0400
From: Ed Tomlinson <edt@aei.ca>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp coupling with scheduler
Date: Wed, 20 Jul 2011 07:31:22 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rcr-crc+; KDE/4.6.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        greearb@candelatech.com
References: <20110720001738.GA16369@linux.vnet.ibm.com> <20110720045414.GC2400@linux.vnet.ibm.com> <201107200723.33819.edt@aei.ca>
In-Reply-To: <201107200723.33819.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107200731.23667.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 July 2011 07:23:32 Ed Tomlinson wrote:

[omitted] 

> Paul/Peter,
> 
> With all 7 fixes applied with the above version of patch 1, I get a warning during boot:

[omitted]

I rebooted to see if the warning was solid and it is.  I'm now running with all 7 patches and will see what happens.
I'll send you a report in a few hours from my work email if all seems ok.  Meanwhile I'll see if I cannot keep this
box busy for a few hours.

Ed
