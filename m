Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0DUCP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:15:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53150
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab0DUCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:15:57 -0400
Date: Tue, 20 Apr 2010 19:16:02 -0700 (PDT)
Message-Id: <20100420.191602.228303800.davem@davemloft.net>
To: osstklei@de.ibm.com
Cc: raisch@de.ibm.com, themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ehea: error handling improvement
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BCC47AB.2090600@de.ibm.com>
References: <4BCC47AB.2090600@de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Klein <osstklei@de.ibm.com>
Date: Mon, 19 Apr 2010 14:08:11 +0200

> Reset a port's resources only if they're actually in an error state
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
> 
> Patch created against 2.6.34-rc4

There are several problems with these patches:

1) They are corrupted by your email client, lines unchanged
   begin with one space character instead of two.  Therefore
   even 'patch' wouldn't accept these changes.

2) The double slash in the patch file paths make git not
   accept the change.  Please don't put double-slashes in
   your patch paths as that canonically means "/".

3) These are not appropriate for net-2.6 as we are deep in
   the -rcX series at this point and only the most diabolical
   bug fixes are appropriate.  Therefore, please generate these
   against net-next-2.6, thanks.
