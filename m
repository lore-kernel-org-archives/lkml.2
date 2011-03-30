Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1C3XoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:44:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43989 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1C3XoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:44:14 -0400
Date: Thu, 31 Mar 2011 01:44:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, jln@google.com,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        Roland Dreier <roland@purestorage.com>, greg@kroah.com
Subject: Re: [PATCH] [226/275] Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code
Message-ID: <20110330234413.GI21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org> <20110330210751.A9ADB3E1A05@tassilo.jf.intel.com> <20110330213338.GA20367@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330213338.GA20367@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If stable needs this change, then it probably needs
> 
> 	Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
> 	commit 243b422af9ea9af4ead07a8ad54c90d4f9b6081a
> 
> as well.

Added thanks.

BTW I think Greg would need that too for .32.

-Andi
