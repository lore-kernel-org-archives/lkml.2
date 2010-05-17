Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0EQXsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:48:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41438
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab0EQXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:48:13 -0400
Date: Mon, 17 May 2010 16:48:21 -0700 (PDT)
Message-Id: <20100517.164821.189684939.davem@davemloft.net>
To: gregkh@suse.de
Cc: ebiederm@xmission.com, greg@kroah.com, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com,
       eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] netns support in the kobject layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100517210318.GA6170@suse.de>
References: <20100517181133.GB18721@kroah.com>
	<m1zkzyfdob.fsf@fess.ebiederm.org>
	<20100517210318.GA6170@suse.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Mon, 17 May 2010 14:03:18 -0700

> On Mon, May 17, 2010 at 01:58:44PM -0700, Eric W. Biederman wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> If I must I will resend these, but these patches are already in
>> production use, and I had them to you weeks before the merge window
>> closed.
> 
> Yes, but they were not reviewed by the network maintainer until after
> the merge window closed.  I already have your sysfs-namespace patches
> queued up for .35, and that's a big enough change for me to feel
> comfortable with at the moment.

Greg, this is complete bullshit.  I reviewed them last week, they are fine
and have been around forever.

Merge them in now, making them wait until 2.6.36 is completely rediculious.
