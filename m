Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab1EaVhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:37:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1EaVhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:37:41 -0400
Date: Tue, 31 May 2011 17:37:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-ID: <20110531213704.GV16382@redhat.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
 <20110203020703.GB21603@redhat.com>
 <20110203135324.93BC.A69D9226@jp.fujitsu.com>
 <20110526131028.7052a893.akpm@linux-foundation.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 04:58:00PM -0400, Seiji Aguchi wrote:
> Hi,
> 
> As Americo said, sometimes kdump doesn't work in the real world.
> 
> So, I would like to keep discussing implementation of kmsg_dump(KMSG_DUMP_KEXEC)
> rather than just removing it.

What are you using kmsg_dump() for? Using mtdoops, ramoops or something
else?  Is it working reliably for you?

Thanks
Vivek
