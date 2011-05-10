Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1EJSUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:20:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1EJSUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:20:15 -0400
Date: Tue, 10 May 2011 20:19:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 02/11] ptrace: implement PTRACE_SEIZE
Message-ID: <20110510181902.GA3273@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-3-git-send-email-tj@kernel.org> <20110509161838.GA27473@redhat.com> <20110510094650.GQ1661@htj.dyndns.org> <20110510132001.GA21834@redhat.com> <20110510134752.GW1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510134752.GW1661@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Tejun Heo wrote:
>
> I think this basically is the same problem as the using TRAPPING on
> PTRACE_DETACH one.  Do you recall the original version where TRAPPING
> was cleared on kill

Yes, and it was me who suggested to not do this ;)

> I think that's what we should do.

Yes, I thought about this too. But I am still not sure, _perhaps_ this
needs more thinking. Just a fuzzy feeling, I do not have any particular
idea right now.

Oleg.

