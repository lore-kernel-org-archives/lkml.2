Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab0HRCMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:12:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35700
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab0HRCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:12:26 -0400
Date: Tue, 17 Aug 2010 19:12:45 -0700 (PDT)
Message-Id: <20100817.191245.112612004.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
References: <20100817.180325.104051399.davem@davemloft.net>
	<AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 18:31:50 -0700

> Confused yet?

Beyond...

> The basic rule becomes: never _ever_ overflow 'int' in a constant,
> without specifying the exact type you want. That way you avoid all the
> subtle cases.

That's easier to understand.
