Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1JRTaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:30:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:32844 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1JRTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:30:34 -0400
Date: Tue, 18 Oct 2011 15:29:23 -0400 (EDT)
Message-Id: <20111018.152923.55645219498274462.davem@davemloft.net>
To: greg@kroah.com
Cc: hch@infradead.org, jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111018141350.GB17101@kroah.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
	<20111018065852.GA6056@infradead.org>
	<20111018141350.GB17101@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 18 Oct 2011 12:29:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Tue, 18 Oct 2011 07:13:50 -0700

> On Tue, Oct 18, 2011 at 02:58:52AM -0400, Christoph Hellwig wrote:
>> On Mon, Oct 17, 2011 at 09:16:39PM -0400, Josh Boyer wrote:
>> > The stable@kernel.org email address has been replaced with the
>> > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
>> > reference the new list instead of the semi-defunct email alias.
>> 
>> Does this mean it already stopped working?  I recently sent pathces
>> there but neither got an ACK nor a bounce or similar.
> 
> It should have bounced.

It doesn't bounce, it's a mailing list looping posting protection at
vger.kernel.org which triggers because it sees certain email header
fields in the forwarded emails from kernel.org that make it look like
a list loop.

We respond to such things silently so we don't exacerbate the loop.
