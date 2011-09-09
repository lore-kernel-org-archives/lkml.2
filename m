Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab1IIQSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab1IIQSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:18:21 -0400
Date: Fri, 9 Sep 2011 18:14:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Message-ID: <20110909161459.GB23271@redhat.com>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com> <20110909001853.GA29319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909001853.GA29319@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Tejun Heo wrote:
>
> To me, the rationale presented here almost argues against
> PTRACE_O_TRACESTOP.  :(

Personally I dislike PTRACE_O_TRACESTOP too.

And once again, this needs more (nontrivial) changes than just
s/PT_SEIZED/PTRACE_O_TRACESTOP/, the patch was wrong.

And, just for example. While this is minor, I'd like to improve
the error codes from ptrace_check_attach(). Until we drop
PTRACE_SEIZE_DEVEL we can safely do this. I don't think it makes
sense to add the new PTRACE_O for this.

And finally, I simply do not understand how it can be useful.

Oleg.

