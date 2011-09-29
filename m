Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1I2Cci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:32:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57338 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab1I2Cc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:32:27 -0400
Date: Wed, 28 Sep 2011 22:28:54 -0400 (EDT)
Message-Id: <20110928.222854.2075305752860630081.davem@davemloft.net>
To: jeremy@goop.org
Cc: jbaron@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        jang@linux.vnet.ibm.com, ddaney@caviumnetworks.com
Subject: Re: Jump Label initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E83D49C.9080809@goop.org>
References: <4E83D49C.9080809@goop.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Sep 2011 19:28:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Wed, 28 Sep 2011 19:14:52 -0700

> I'm experimenting at the moment with a patch to allow
> jump_label_enable() to be called fairly early, and have that be
> respected by jump_label_init().  I'm doing this by replacing
> arch_jump_label_poke_text_early() with
> arch_jump_label_transform_early(), which shares most of its code with
> its non-early variant, except that it expects to run in a pre-SMP
> environment.
> 
> Does this seem plausible? (I haven't tested it yet.)

I have no objections to this.
