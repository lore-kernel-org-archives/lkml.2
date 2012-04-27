Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2D0QWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:22:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43382 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab2D0QWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:22:53 -0400
Date: Fri, 27 Apr 2012 12:22:07 -0400 (EDT)
Message-Id: <20120427.122207.795060203454499065.davem@davemloft.net>
To: mjt@tls.msk.ru
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, raven@themaw.net, thomas@m3y3r.de,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9A6ABA.6050503@msgid.tls.msk.ru>
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru>
	<CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com>
	<4F9A6ABA.6050503@msgid.tls.msk.ru>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 09:22:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Tokarev <mjt@tls.msk.ru>
Date: Fri, 27 Apr 2012 13:45:30 +0400

> Please note: the talk is about 32bit userspace on 64bit kernel,
> which should be quite rare these days, or something of less
> priority.

You're talking about %99 of powerpc and sparc systems.
