Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1BCExI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:53:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55698 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab1BCExG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:53:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg hook into crash_kexec())
Cc: kosaki.motohiro@jp.fujitsu.com, Americo Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>, akpm@linux-foundation.org
In-Reply-To: <20110203020703.GB21603@redhat.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com> <20110203020703.GB21603@redhat.com>
Message-Id: <20110203135324.93BC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Feb 2011 13:53:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I wrote why this is no good idea by another mail. Please see it.
> > Anyway you have a right to don't use this feature.
> > 
> 
> But you have not explained that why do you need to hook into crash_kexec()
> and you have also not explained why do you need to send out kdump_msg()
> notification if kdump is configured.
> 
> Some detailed explanation here would help.

Hi,

I send it you now :)



