Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1HWWMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:12:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60300 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1HWWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110823220158.GA28444@count0.beaverton.ibm.com>
References: <20110727163159.GA23785@redhat.com>
	<20110729192358.GB31717@mtj.dyndns.org>
	<20110812175550.GA7484@redhat.com>
	<20110813161814.GE4254@htj.dyndns.org>
	<20110823220158.GA28444@count0.beaverton.ibm.com>
Date: Wed, 24 Aug 2011 00:12:44 +0200
X-Google-Sender-Auth: onJ8PX1wq5ckVY9P2mjHciix27A
Message-ID: <CAOS58YOsjLRWnbgfP=b=mZL6MtTZQExWvR9XkrJiHDYU0BEZrw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] make vfork killable
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Wed, Aug 24, 2011 at 12:01 AM, Matt Helsley <matthltc@us.ibm.com> wrote:
> Are you proposing one new jobctl state for vfork and another for
> the cgroup freezer?

Dunno how it would actually turn out yet, but no matter how, it would
be transparent to the process itself while being visible to and
manipulatable by ptracer.  Well, that's the idea...

Thanks.

-- 
tejun
