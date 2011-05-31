Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1EaU6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:58:18 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:62865 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1EaU6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:58:17 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Americo Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Date: Tue, 31 May 2011 16:58:00 -0400
Subject: RE: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Thread-Topic: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Thread-Index: Acwb4RI5KWUlRdgxQRaVCO8Kyg3SKAD8pxsQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
	<20110203020703.GB21603@redhat.com>
	<20110203135324.93BC.A69D9226@jp.fujitsu.com>
 <20110526131028.7052a893.akpm@linux-foundation.org>
In-Reply-To: <20110526131028.7052a893.akpm@linux-foundation.org>
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

As Americo said, sometimes kdump doesn't work in the real world.

So, I would like to keep discussing implementation of kmsg_dump(KMSG_DUMP_KEXEC)
rather than just removing it.

Seiji
