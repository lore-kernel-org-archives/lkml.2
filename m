Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1ELSGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:06:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57245 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab1ELSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:06:36 -0400
Date: Thu, 12 May 2011 14:06:30 -0400 (EDT)
Message-Id: <20110512.140630.1779004012724490077.davem@davemloft.net>
To: eranian@google.com
Cc: acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 11:06:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>
Date: Thu, 12 May 2011 16:48:46 +0200

> I think there is a serious problem with kernel symbol correlation
> with the latest perf in 2.6.39-rc7-tip.

The behavior seems to be intentional, so that we don't expose internal
kernel addresses to userspace.

I hate this too, and I think it's absolutely rediculous.

Also, like you, I lost an entire afternoon trying to figure out why
this started happening.

I wish we could revert this change.
