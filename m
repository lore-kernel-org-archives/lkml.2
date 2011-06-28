Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab1F1QtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:49:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53668 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759390Ab1F1QtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:49:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110628163512.GA11937@redhat.com>
References: <201106262108.43011.vda.linux@googlemail.com>
	<20110626200442.GA16293@redhat.com>
	<20110627081139.GY30101@htj.dyndns.org>
	<20110627134713.GB3527@redhat.com>
	<20110627135252.GB30101@htj.dyndns.org>
	<20110627151827.GA6223@redhat.com>
	<20110628082512.GA3386@htj.dyndns.org>
	<BANLkTik2KqKGwBAqN+CSz7_ergx5VM9x4A@mail.gmail.com>
	<20110628123823.GD3386@htj.dyndns.org>
	<20110628163512.GA11937@redhat.com>
Date: Tue, 28 Jun 2011 18:49:01 +0200
X-Google-Sender-Auth: HI5WjpsZhfjRs08Zp0IJzqpGxxg
Message-ID: <BANLkTikFNs6ZyoRKo=_65JpqwJLd-E1UwQ@mail.gmail.com>
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 28, 2011 at 6:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> I do not really understand your concerns. Yes, yes, yes, if we do not
> bind this feauture with PT_SEIZED, then the application has to take
> care _if_ it wants to use it without PT_SEIZED. So what? This is the
> problem of that application. This change can't break the application
> which do not want or do not know about this feature.

It's not really a technical concern, more about documentation
simplicity.  It's just simpler to be able to say "blah blah changes
when seized".

> a bit better, bit still not very nice. For what? I tend to agree with
> Denys, and I think we should listen to the user-space developer who
> actually uses ptrace.
>
> That said, I leave it to you and Denys, personally I am fine either way.

It's minor either way.  Let's go with the current patch then.

Thanks.

-- 
tejun
