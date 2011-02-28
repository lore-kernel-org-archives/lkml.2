Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1B1ShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:37:10 -0500
Received: from www.tglx.de ([62.245.132.106]:56330 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1B1ShJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:37:09 -0500
Date: Mon, 28 Feb 2011 19:36:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: J Freyensee <james_p_freyensee@linux.intel.com>
cc: Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 03/10] Intel PTI implementaiton of MIPI 1149.7.
In-Reply-To: <1298915213.3156.32.camel@localhost>
Message-ID: <alpine.LFD.2.00.1102281935260.2701@localhost6.localdomain6>
References: <james_p_freyensee@linux.intel.com>  <1298570824-26085-4-git-send-email-james_p_freyensee@linux.intel.com>  <201102281028.48314.arnd@arndb.de> <1298915213.3156.32.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011, J Freyensee wrote:
> On Mon, 2011-02-28 at 10:28 +0100, Arnd Bergmann wrote:
> > > +static struct miscdevice pti_char_driver = {
> > > +	.minor		= MISC_DYNAMIC_MINOR,
> > > +	.name		= CHARNAME,
> > > +	.fops		= &pti_char_driver_ops
> > > +};
> > > +
> > 
> > It's really strange to have both a tty and a character device that have similar
> > operations. Why can't you have the pti_char_driver functionality in the tty driver?
> > 
> 
> Because that is not what the customer wanted and this is why the driver
> is located in misc/ ;-).  

Brilliant argument. Next time you tell us that the customer wanted a
root hole in his driver and that's why you put it there.

What's the fcking technical reason for having a char and a tty device ?

Thanks,

	tglx
