Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab0KRUKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:10:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:59989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab0KRUKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:10:41 -0500
Date: Thu, 18 Nov 2010 12:10:35 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118201035.GA26287@suse.de>
References: <20101118163321.GA2723@suse.de>
 <4CE5562B.8080604@freescale.com>
 <20101118165136.GA3103@suse.de>
 <4CE55ACB.80207@freescale.com>
 <20101118171856.GA4283@suse.de>
 <4CE5647F.5000203@freescale.com>
 <20101118175832.GA4931@suse.de>
 <4CE58005.7040308@freescale.com>
 <20101118200230.GA25715@suse.de>
 <4CE58736.4090703@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE58736.4090703@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:06:14PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> > Does that work for you?  Looks fine to me :)
> 
> Ok!
> 
> > But again, you really should get the driver model portion right...
> 
> I'll do that.
> 
> One last question.  If I create multiple TTY devices, how do I tell the kernel
> which one should be used for the console?

On the command line.
