Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0J2FDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:03:33 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:49207 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0J2FDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:03:30 -0400
Date: Fri, 29 Oct 2010 01:03:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: intel idle kconfig warning
In-reply-to: <20101028122045.GA6774@basil.fritz.box>
Message-id: <alpine.LFD.2.00.1010290053530.4117@localhost.localdomain>
References: <20101028122045.GA6774@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> include/config/auto.conf:4352:warning: symbol value 'm' invalid for INTEL_IDLE
> 
> Some problem with the intel idle Kconfig?

I'm unable to reproduce this warning.

Note that CONFIG_INTEL_IDLE has been boolean since 2.6.36.
It was tristate in 2.6.35.  Is there some sort of stale state
on your build system?

thanks,
Len Brown, Intel Open Source Technology Center

