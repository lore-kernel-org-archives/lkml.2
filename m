Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1JKDFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:05:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38354 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1JKDFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:05:10 -0400
Date: Mon, 10 Oct 2011 23:05:00 -0400 (EDT)
Message-Id: <20111010.230500.1524387763129785129.davem@davemloft.net>
To: hpa@zytor.com
Cc: gregkh@suse.de, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: stable mailing list?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E9389A5.1080300@zytor.com>
References: <1318290984.7904.127.camel@gandalf.stny.rr.com>
	<20111011000759.GA28709@suse.de>
	<4E9389A5.1080300@zytor.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 10 Oct 2011 20:05:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 10 Oct 2011 17:11:17 -0700

> On 10/10/2011 05:07 PM, Greg KH wrote:
>> On Mon, Oct 10, 2011 at 07:56:23PM -0400, Steven Rostedt wrote:
>>> I received a bounce from stable@kernel.org. What should we be Ccing to?
>> 
>> You should be marking your patch with a:
>> 	Cc: stable <stable@kernel.org>
>> 
>> and when it hits Linus's tree, I properly pick it up.  Right now, the
>> mailing list isn't working, and I am considering just having it point to
>> a vger list as that makes more sense.  I'll ask Dave to set this up when
>> I land as I'm traveling at the moment...
>> 
> 
> Hi Dave,
> 
> Can you set up <stable@vger.kernel.org> and we'll point
> <stable@kernel.org> to it?

Done.
