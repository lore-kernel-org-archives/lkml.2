Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab0I0RCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab0I0RCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:02:40 -0400
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov, jengelh@medozas.de,
        paul.moore@hp.com, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
In-Reply-To: <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
	 <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 13:01:36 -0400
Message-ID: <1285606896.2815.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 10:50 +1000, James Morris wrote:
> On Fri, 24 Sep 2010, Eric Paris wrote:

> For the reasons above, I think the secctx string needs to be exported in 
> addition to this rather than instead of.

I won't argue, I don't agree with your reasoning, but I'm not opposed to
this result.  We have 3 competing suggestions:

Jan suggested we:
completely eliminate secmark from procfs+netlink and only export secctx
in netlink.

Eric suggested we:
completely eliminate secmark from procfs+netlink and then export secctx
in procfs+netlink

sounds like James suggested we:
continue to export meaningless and confusing secmark from procfs+netlink
and then export secctx in procfs+netlink as well.

I'm going to implement James' idea and resend the patch series.  Any
strong objections?

-Eric

