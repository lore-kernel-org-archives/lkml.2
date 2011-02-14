Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1BNUlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:41:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1BNUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:41:09 -0500
Date: Mon, 14 Feb 2011 12:13:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
Message-Id: <20110214121308.b5be78a5.akpm@linux-foundation.org>
In-Reply-To: <m1wrl2pfio.fsf@fess.ebiederm.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	<m1r5bbthan.fsf@fess.ebiederm.org>
	<m1fwrrtc0m.fsf@fess.ebiederm.org>
	<m139nqsk3q.fsf@fess.ebiederm.org>
	<AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
	<AANLkTimwbkQQkwcX19NVcmSfv5O1dP9oeEBegbQLSh60@mail.gmail.com>
	<AANLkTi=CZ8v99yojSb0Ci=5N9dVFr-vDeZM1_Amx_scj@mail.gmail.com>
	<m1wrl2pfio.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 11:44:47 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> My three boot attempts with CONFIG_DEBUG_PAGEALLOC are below.
> 
> 
> ERROR: kmemcheck: Fatal error

It might be that kmemcheck and DEBUG_PAGE_ALLOC don't get along well -
try disabling kmemcheck?

It's worth persisting with DEBUG_PAGE_ALLOC, please - if we can get it
working then it should be able to find a stray write into a freed 8k page
with precision.

