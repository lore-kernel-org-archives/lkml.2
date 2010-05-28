Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab0E1Rmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:42:55 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:47343 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab0E1Rmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:42:50 -0400
Date: Fri, 28 May 2010 13:42:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] idle-test patches queued for upstream
In-reply-to: <201005281007.34706.trenn@suse.de>
Message-id: <alpine.LFD.2.00.1005281339010.4045@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <201005271045.33500.trenn@suse.de>
 <alpine.LFD.2.00.1005272023510.24823@localhost.localdomain>
 <201005281007.34706.trenn@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, Windows uses ACPI.
> > On the Dell above, that is why Linux consumes 15% less idle power
> > and why Linux can take advantage of turbo mode and Windows can not.

> You always propageted to stay Windows compatible...
> Now we go the untested way.
> Let's see how much machines will break...
> 
> Thanks for clarifications,

Don't get me wrong, Linux' ACPI "compatibility" is a huge asset.

However, there are opportunities for Linux to do better than Windows,
and I believe this is one of them.  Yes, when we take the risk of
doing something that Windows does not do, there will always be
the possibility that we will fail.

cheers,
-Len Brown, Intel Open Source Technology Center
