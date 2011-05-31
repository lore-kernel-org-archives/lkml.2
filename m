Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab1EaWY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:24:59 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:39169 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab1EaWY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:24:58 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Date: Tue, 31 May 2011 18:24:14 -0400
Subject: RE: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Thread-Topic: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Thread-Index: Acwf2uSQJoETBjzZTKW3jybJgVyGygABBPNw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C17324BB9@USINDEVS01.corp.hds.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
 <20110203020703.GB21603@redhat.com>
 <20110203135324.93BC.A69D9226@jp.fujitsu.com>
 <20110526131028.7052a893.akpm@linux-foundation.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>
 <20110531213704.GV16382@redhat.com>
In-Reply-To: <20110531213704.GV16382@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>What are you using kmsg_dump() for? Using mtdoops, ramoops or something
>else?  Is it working reliably for you?

I plan to use kmsg_dump() for set_variable service of UEFI.
I proposed a prototype patch this month and will improve it.
(kmsg_dump is used inside pstore.)

https://lkml.org/lkml/2011/5/10/340

Seiji

