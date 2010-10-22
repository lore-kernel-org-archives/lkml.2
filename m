Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0JVR4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:56:32 -0400
Received: from kroah.org ([198.145.64.141]:50633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab0JVR4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:56:30 -0400
Date: Fri, 22 Oct 2010 10:56:24 -0700
From: Greg KH <greg@kroah.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Message-ID: <20101022175624.GA13640@kroah.com>
References: <4CA653F0.1010008@vlnb.net>
 <4CA656AD.8020408@vlnb.net>
 <20101009212047.GB27180@kroah.com>
 <4CB36592.6060909@vlnb.net>
 <20101011213235.GA11489@kroah.com>
 <4CB4AEB9.30501@vlnb.net>
 <20101012190345.GA25737@kroah.com>
 <4CB75E81.7000208@vlnb.net>
 <20101014200413.GA30831@kroah.com>
 <4CC1CA4D.1090609@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC1CA4D.1090609@vlnb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 09:30:53PM +0400, Vladislav Bolkhovitin wrote:
> +	unsigned int tgt_kobj_initialized:1;

It's the middle of the merge window, and I'm about to go on vacation, so
I didn't read this patch after this line.

It's obvious that this patch is wrong, you shouldn't need to worry about
this.  And even if you did, you don't need this flag.

Why are you trying to do something that no one else needs?  Why make
things harder than they have to be.

{sigh}

greg k-h
