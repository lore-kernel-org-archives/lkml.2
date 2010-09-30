Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0I3Iib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:38:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0I3Ii3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:38:29 -0400
From: Andi Kleen <andi@firstfloor.org>
To: holzheu@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise accounting
References: <1285249681.1837.28.camel@holzheu-laptop>
cc: linux-kernel@vger.kernel.org
Date: Thu, 30 Sep 2010 10:38:26 +0200
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop> (Michael Holzheu's
	message of "Thu, 23 Sep 2010 15:48:01 +0200")
Message-ID: <871v8bwrr1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
>
> Compared to the old top command that has to scan more than 1000 proc
> directories the new ptop consumes much less CPU time (0.05% system time
> on my s390 system).

Sounds like a nice advantage (and in a way goes back to old kmem ps) 

Are there plans to make the standard top command use this new interface
or will it be only something for specialized utilities?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
