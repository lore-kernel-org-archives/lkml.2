Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1DMR6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:58:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42981
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1DMR6M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:58:12 -0400
Date: Wed, 13 Apr 2011 10:57:37 -0700 (PDT)
Message-Id: <20110413.105737.39178380.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: bp@amd64.org, linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Be verbose when unable to load fw patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110413174852.GC17579@electric-eye.fr.zoreil.com>
References: <1302615172-1646-1-git-send-email-bp@amd64.org>
	<20110412.162036.241924043.davem@davemloft.net>
	<20110413174852.GC17579@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: François Romieu <romieu@fr.zoreil.com>
Date: Wed, 13 Apr 2011 19:48:52 +0200

> On Tue, Apr 12, 2011 at 04:20:36PM -0700, David Miller wrote:
> [...]
>> Seems reasonable, Francois?
> 
> Yes, it makes sense.
> 
> The patch goes way beyond 80 cols but I'll do a round of
> cleanups later anyway.

Ok.  So will you submit this yourself later or should I just
apply this myself directly to net-2.6?

I'm fine either way.

Thanks!
