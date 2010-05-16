Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0EPG0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 02:26:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41822
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab0EPG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 02:26:35 -0400
Date: Sat, 15 May 2010 23:26:43 -0700 (PDT)
Message-Id: <20100515.232643.212422307.davem@davemloft.net>
To: greg@kroah.com
Cc: ebiederm@xmission.com, gregkh@suse.de, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com,
       eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] netns support in the kobject layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100506200404.GA21805@kroah.com>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
	<m1d3xb4239.fsf@fess.ebiederm.org>
	<20100506200404.GA21805@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Thu, 6 May 2010 13:04:04 -0700

> On Tue, May 04, 2010 at 05:35:54PM -0700, Eric W. Biederman wrote:
>> 
>> With the tagged sysfs support finally merged into Greg's tree,
>> it is time for the last little bits of work to get the kobject
>> layer and network namespaces to play together properly.
>> 
>> These patches are roughly evenly divided between network layer work
>> and sysfs layer work.  Last time this conundrum came up I believe
>> we decided that the easiest way to handle this was for Greg to carry
>> all of the patches.  David, Greg does that still make sense?
> 
> That's fine, if I get David's ack on these.

Looks good to me:

Acked-by: David S. Miller <davem@davemloft.net>
