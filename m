Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0JIAEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:04:12 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:39559 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587Ab0JIAEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:04:11 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anton@samba.org" <anton@samba.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>
Date: Fri, 8 Oct 2010 20:02:58 -0400
Subject: RE: [RFC][PATCH] Fix kexec abort due to IPI from panic().
Thread-Topic: [RFC][PATCH] Fix kexec abort due to IPI from panic().
Thread-Index: ActeZWlIH8saK4u5SBSwPHVq2V1Y4gI3zRGQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C119E5ACE@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
	<m1wrql2sf1.fsf@fess.ebiederm.org>
	<5C4C569E8A4B9B42A84A977CF070A35B2C0DCFFB3E@USINDEVS01.corp.hds.com>
 <m1eicfp1fz.fsf@fess.ebiederm.org>
In-Reply-To: <m1eicfp1fz.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric

Thank you for your detailed explanation.
I understood historic backdrop of kexec in upstream kernel.
I also understood the reason why you are worried about 
kmsg_dump in kexec path.

The problem is that kmsg_dumper or notifier calls are used by people 
who are unfamiliar with kexec because they use blocking-functions 
such as do_gettimeofday unconsciously.

And I still believe that kmsg_dumper in kexec path is an useful 
A troubleshooting feature.

When kexec on panic fails, it is difficult to investigate the reason 
why kexec fails. It comes from lack of materials for the investigation.

Kernel buffer is helpful for the investigation.
So, I would like to continue the discussion about a way of getting 
kernel buffer in kexec path.

I'll participate in End User Summit and Linux Plumbers Conference.
I'd like to meet with you if you join these conferences. 

Seiji
