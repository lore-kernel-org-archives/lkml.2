Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab1EZULG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:11:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758389Ab1EZULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:11:04 -0400
Date: Thu, 26 May 2011 13:10:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Americo Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-Id: <20110526131028.7052a893.akpm@linux-foundation.org>
In-Reply-To: <20110203135324.93BC.A69D9226@jp.fujitsu.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
	<20110203020703.GB21603@redhat.com>
	<20110203135324.93BC.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Feb 2011 13:53:01 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > I wrote why this is no good idea by another mail. Please see it.
> > > Anyway you have a right to don't use this feature.
> > > 
> > 
> > But you have not explained that why do you need to hook into crash_kexec()
> > and you have also not explained why do you need to send out kdump_msg()
> > notification if kdump is configured.
> > 
> > Some detailed explanation here would help.
> 
> Hi,
> 
> I send it you now :)
> 

What happened with this?  kexec-remove-kmsg_dump_kexec.patch has two acks
and one unexplained nack :(
