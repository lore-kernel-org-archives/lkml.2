Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1DELsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 07:48:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1DELsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 07:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZPEJ6XnX3H7mhg8qa/lNXuBxq0vuQL2IJqZ45IUilgG3kgGvpAlpFvtQrzcBnOjDHg
         zkJF1Shkx/2kAvQdWjY+oMx2zB3xYD0FxJC3LJ1NS22HBwGsZtygcqj+CZJim0kIyCot
         ZtX6kq47rOuumcwzFs81jiHpeltLfNevgEdKY=
Date: Tue, 5 Apr 2011 15:47:57 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-ID: <20110405114757.GA32235@oksana.dev.rtsoft.ru>
References: <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com>
 <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
 <20110403120344.GA1540@oksana.dev.rtsoft.ru>
 <20110403140750.GB5670@pulham.picochip.com>
 <BANLkTikoODn75U=DKiqT9xV6kVsjr5T2fA@mail.gmail.com>
 <20110403152244.GC5670@pulham.picochip.com>
 <20110405024838.GA29522@ponder.secretlab.ca>
 <20110405081817.GA4797@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110405081817.GA4797@pulham.picochip.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 09:18:18AM +0100, Jamie Iles wrote:
[...]
> OK, I'll start having a look at this then.  I have a few other things on 
> at the moment so it may take me a little while to get onto it but I'll 
> try and get some patches posted fairly quickly.

Great!

> Anton, I'm happy to do some of the changes that Thomas suggested such as 
> removing some of the runtime calculations

Sure thing, feel free to make the changes.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
