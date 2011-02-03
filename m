Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1BCA7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:59:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43733 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1BCA7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:59:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg hook into crash_kexec())
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>, akpm@linux-foundation.org
In-Reply-To: <20110201081313.GC21239@cr0.nay.redhat.com>
References: <20110201073853.GB21239@cr0.nay.redhat.com> <20110201081313.GC21239@cr0.nay.redhat.com>
Message-Id: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Feb 2011 09:59:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 01, 2011 at 03:38:53PM +0800, Américo Wang wrote:
> >On Mon, Jan 31, 2011 at 11:33:15PM -0800, Eric W. Biederman wrote:
> >>The issue is the inane call inside crash_kexec.
> >>
> >>It requires both a kexec kernel to be loaded and it requires you to be
> >>crashing.  Given that when I audited the kmsg_dump handlers they really
> >>weren't safe in a crash dump scenario we should just remove it.
> >>
> >
> >Probably, I think we need to get rid of KMSG_DUMP_KEXEC.
> >
> 
> Here we go.
> 
> --------->
> 
> KMSG_DUMP_KEXEC is useless because we already save kernel messages
> inside /proc/vmcore, and it is unsafe to allow modules to do
> other stuffs in a crash dump scenario.
> 
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

I wrote why this is no good idea by another mail. Please see it.
Anyway you have a right to don't use this feature.

Nack.


