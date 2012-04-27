Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923Ab2D0R3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:29:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43956 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760326Ab2D0R3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:29:23 -0400
Date: Fri, 27 Apr 2012 13:28:50 -0400 (EDT)
Message-Id: <20120427.132850.1570993918539888078.davem@davemloft.net>
To: mjt@tls.msk.ru
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, raven@themaw.net, thomas@m3y3r.de,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9AD31F.8080109@msgid.tls.msk.ru>
References: <4F9A6ABA.6050503@msgid.tls.msk.ru>
	<20120427.122207.795060203454499065.davem@davemloft.net>
	<4F9AD31F.8080109@msgid.tls.msk.ru>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 10:28:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Tokarev <mjt@tls.msk.ru>
Date: Fri, 27 Apr 2012 21:10:55 +0400

> On 27.04.2012 20:22, David Miller wrote:
>> From: Michael Tokarev <mjt@tls.msk.ru>
>> Date: Fri, 27 Apr 2012 13:45:30 +0400
>> 
>>> Please note: the talk is about 32bit userspace on 64bit kernel,
>>> which should be quite rare these days, or something of less
>>> priority.
>> 
>> You're talking about %99 of powerpc and sparc systems.
> 
> Nope.  Only about x86 32 on 64 bits, and only with 3.3 kernel.
> The original problem does not exist on ppc, at least as far as
> I understand.

I was making a general point about 32-bit userspace on a 64-bit
kernel, but yes for this specific bug the issue doesn't exist.
