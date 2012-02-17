Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2BQCys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:54:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2BQCyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:54:47 -0500
Date: Thu, 16 Feb 2012 21:54:31 -0500 (EST)
Message-Id: <20120216.215431.1415875817745523201.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [21/28] crypto: sha512 - Avoid stack bloat on i386
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120217023742.GA21909@kroah.com>
References: <20120217021718.GA21573@kroah.com>
	<20120217022806.GA4980@gondor.apana.org.au>
	<20120217023742.GA21909@kroah.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Feb 2012 18:54:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 16 Feb 2012 18:37:42 -0800

> On Fri, Feb 17, 2012 at 01:28:06PM +1100, Herbert Xu wrote:
>> On Thu, Feb 16, 2012 at 06:17:18PM -0800, Greg KH wrote:
>> > On Thu, Feb 16, 2012 at 08:52:31PM -0500, David Miller wrote:
>> > > From: Greg KH <gregkh@linuxfoundation.org>
>> > > Date: Thu, 16 Feb 2012 16:55:55 -0800
>> > > 
>> > > > 3.2-stable review patch.  If anyone has any objections, please let me know.
>> > > 
>> > > This causes a stack usage regression on sparc that Herbert
>> > > is in the middle of merging a fix for into Linus's tree.
>> > 
>> > Ick.  Any idea when that will hit Linus's tree?  If it's before next
>> > Monday, we are good, and I can queue it up here, if not, then I'll drop
>> > this and have to add it back later.
>> 
>> I've pushed it though it hasn't been pulled yet:
>> 
>> The commit ID is f2ea0f5f04c97b48c88edccba52b0682fbe45087.
> 
> Thanks, I'll watch out for it.

Greg, keep in mind that this stuff is in your 3.0-stable series too.
