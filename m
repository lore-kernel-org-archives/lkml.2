Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab2ADTj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:39:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52199 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2ADTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:39:56 -0500
Date: Wed, 04 Jan 2012 14:39:29 -0500 (EST)
Message-Id: <20120104.143929.962116161801444281.davem@davemloft.net>
To: greg@kroah.com
Cc: James.Bottomley@HansenPartnership.com, Nagalakshmi.Nandigama@lsi.com,
        stable@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org,
        Eric.Moore@lsi.com
Subject: Re: [PATCH] mpt2sas: fix non-x86 crash on shutdown
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120104192102.GB18214@kroah.com>
References: <1325690398.2758.10.camel@dabdike.int.hansenpartnership.com>
	<1325690713.2758.13.camel@dabdike.int.hansenpartnership.com>
	<20120104192102.GB18214@kroah.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Jan 2012 11:39:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 4 Jan 2012 11:21:02 -0800

> On Wed, Jan 04, 2012 at 09:25:13AM -0600, James Bottomley wrote:
>> From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>
> 
> That's not a correct "from" line, sorry.  That would create a mess of
> the log.  Oh, I see Linus's tree is already a mess here, ugh.  Please be
> more careful when accepting patches, otherwise stuff like this causes me
> to have to hand-edit the kernel git logs when I run the "who does what"
> statistic reports...
> 
> David, any objection for me taking this patch (left below) instead of
> your original one for the stable tree?

No objection.
