Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab2KPMH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:07:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:44451 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab2KPMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:07:57 -0500
Date: Fri, 16 Nov 2012 04:08:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Constantine Shulyupin <const@MakeLinux.com>, linux-kernel@vger.kernel.org,
        celinux-dev@lists.celinuxforum.org, Ryan Mallon <rmallon@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Selim TEMUR <selimtemur@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] LDT - Linux Driver Template
Message-ID: <20121116120836.GB13498@kroah.com>
References: <1353007337-12791-1-git-send-email-const@MakeLinux.com>
 <20121115224030.GA16377@kroah.com>
 <87zk2hubh1.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zk2hubh1.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 10:46:18AM +0100, Bjørn Mork wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> >  Normally you just start with a
> > driver for a device like the one you need to write and modify it from
> > there.
> 
> Yes.
> 
> Even if the template driver is fixed up to be the most beautiful driver
> ever made, it will still always be made for non-existing hardware.  This
> causes two major problems:
>  - the driver will not be tested, so it will have bugs
>  - the driver will not be used by anyone, so it will not be maintained
>    (remember that it is initially perfect, so there is no reason to
>    change it)
> 
> May I suggest another approach?  How about selecting a set of existing
> drivers which are suitable as templates, and put all this effort into
> making those drivers *the* perfect examples instead? Start submitting
> cleanup patches for the selected drivers until everyone is satisfied and
> then document them as starting points for anyone wanting to write a
> similar driver.

I agree, this is a much better idea.  Basing any new driver on a
known-working driver is highly preferable.

thanks,

greg k-h
