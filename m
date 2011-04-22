Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1DVSCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:02:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34740 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab1DVSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m2eeQ+vtIflp+wuO+6eRLnqoOo0p3WT0UDXpd7SDByyoW5a0dlkcCTWVCYBLwnDS8i
         oGiKwm2xXM8qn4LXbyFsHvehEnHs14IwIIBUw7AoJt6Dh+gvf1eyhj+QaMUeSGdLMZV7
         Fqwu0DxnzEXnYJkuzi1QScyzMSWB4ZwT3y1V0=
Date: Fri, 22 Apr 2011 20:01:58 +0200
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Steven Whitehouse <swhiteho@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110422180158.GB21902@mtj.dyndns.org>
References: <1302638216.2604.35.camel@mulgrave.site>
 <1302640226.2661.34.camel@dolmen>
 <1302641036.2604.40.camel@mulgrave.site>
 <20110413051846.GD24161@mtj.dyndns.org>
 <20110413060651.GA27823@mtj.dyndns.org>
 <1302686454.2613.4.camel@dolmen>
 <1302703208.2613.18.camel@dolmen>
 <1302714080.2597.29.camel@mulgrave.site>
 <4DA603AF.9090202@fusionio.com>
 <1302725866.2597.33.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302725866.2597.33.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Wed, Apr 13, 2011 at 03:17:46PM -0500, James Bottomley wrote:
> On Wed, 2011-04-13 at 22:12 +0200, Jens Axboe wrote:
> > This patch looks pretty clean. Shouldn't you serialize that ->queuedata
> > = NULL assignment with the queue lock, though?
> 
> pointer assignment is atomic, isn't it?  As in on a 32 bit arch, it
> definitely is, and I thought on 64 bits it also was.  So a simultaneous
> reader either sees previous value or NULL.

What was the conclusion of this thread?  James' fix seems minimal and
good for this cycle but I don't see it there yet.  Jens, James?

Thanks.

-- 
tejun
