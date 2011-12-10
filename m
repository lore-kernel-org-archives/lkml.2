Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1LJA05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 19:26:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46988 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab1LJA0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 19:26:55 -0500
Date: Fri, 09 Dec 2011 19:24:39 -0500 (EST)
Message-Id: <20111209.192439.275865894437319638.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: lersek@redhat.com, konrad.wilk@oracle.com, jeremy@goop.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 REPOST] xen-netfront: delay gARP until backend
 switches to Connected
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323465781.20936.49.camel@dagon.hellion.org.uk>
References: <1323430738-3798-1-git-send-email-lersek@redhat.com>
	<20111209.134514.2071890208094978847.davem@davemloft.net>
	<1323465781.20936.49.camel@dagon.hellion.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 09 Dec 2011 16:24:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Fri, 9 Dec 2011 21:23:00 +0000

> On Fri, 2011-12-09 at 18:45 +0000, David Miller wrote:
>> From: Laszlo Ersek <lersek@redhat.com>
>> Date: Fri,  9 Dec 2011 12:38:58 +0100
>> 
>> > These two together provide complete ordering. Sub-condition (1) is
>> > satisfied by pvops commit 43223efd9bfd.
>> 
>> I don't see this commit in Linus's tree,
> 
> The referenced commit is in
> git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git#xen/next-2.6.32  some people call the "pvops tree" but there's no reason to expect someone outside the Xen world to know that...
> 
> A better reference would have been 6b0b80ca7165 in
> git://xenbits.xen.org/people/ianc/linux-2.6.git#upstream/dom0/backend/netback-history which is the precise branch that was flattened to make f942dc2552b8, which is the upstream commit that added netback, so this change is already in upstream.

I want the commit message fixed so someone seeing the commit ID can
figure out what it actually refers to.
