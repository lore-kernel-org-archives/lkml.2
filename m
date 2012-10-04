Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab2JDAzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:55:17 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61705 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936Ab2JDAzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <506C4FD0.4040307@att.net>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
	<1348874411-28288-8-git-send-email-daniel.santos@pobox.com>
	<20120929002626.GD13907@jtriplet-mobl1>
	<50664308.6020601@att.net>
	<20120929005043.GD14293@jtriplet-mobl1>
	<alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com>
	<20121003065959.GA4963@leaf>
	<alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com>
	<506C1F8B.1070307@att.net>
	<1349272914.22822.169.camel@gandalf.local.home>
	<506C4FD0.4040307@att.net>
Date: Wed, 3 Oct 2012 17:55:12 -0700
Message-ID: <CANN689GMAdhYsxGy3-ZKs8Ey4+OYgN+uKq5YPDfZSbrWAVAi-Q@mail.gmail.com>
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function attribute
From: Michel Lespinasse <walken@google.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Rientjes <rientjes@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 7:46 AM, Daniel Santos <danielfsantos@att.net> wrote:
> On 10/03/2012 09:01 AM, Steven Rostedt wrote:
>> You don't need to use get_maintainers. It's more of a help tool to find
>> maintainers and not something that is mandatory. Not everyone that has
>> ever touched one of these files needs to be Cc'd.
>>
>> Please move the patch to the patch series where it is used. Otherwise it
>> confuses reviewers as it did here.
> Ok then, but this would also apply to the addition of these macros as well:
> BUILD_BUG_ON_NON_CONST
> BUILD_BUG42
> BUILD_BUG_ON_NON_CONST42
>
> Should these then also be moved?

Yes, this would actually make things easier.

> Should I only CC those who have responded to these patches and whomever
> is in the MAINTAINERS file then?

There is no strong rule here, but generally get_maintainers returns
too many people. You want to trim down the list to something shorter;
a dozen people is the most I would consider (but for most patches a
half-dozen is already plenty).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
