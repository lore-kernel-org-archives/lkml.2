Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2ASHDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:03:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab2ASHDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:03:33 -0500
Date: Wed, 18 Jan 2012 22:50:53 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_phub: add message to notify installing pch_phub
Message-ID: <20120119065053.GB7270@suse.de>
References: <1326935267-4077-1-git-send-email-tomoya.rohm@gmail.com>
 <20120119012130.GA6050@suse.de>
 <CANKRQnikxUjtUjnKZ=GkV1kLUVx_N2ipSr86PiJrm=iZq_Mhaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnikxUjtUjnKZ=GkV1kLUVx_N2ipSr86PiJrm=iZq_Mhaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:22:24AM +0900, Tomoya MORINAGA wrote:
> 2012/1/19 Greg KH <gregkh@suse.de>:
> > No, I'm going to reject this, we have been _removing_ these types of
> > garbage messages from drivers, please don't add new ones, it is
> > pointless.
> >
> 
> You mean you can't allow only one-line driver installed message ?

Nope, why are they needed, they are wasted space and time.

> If yes, let me know your opinion about below.
> How users can know the driver is installed or not ?

They use the device and it works?

That's all that is really needed, right? :)

If that doesn't work, they can look in the module list, or in sysfs,
like you said people already do today.  But why would they need to look,
your driver should be automatically loaded already, no user should ever
care about loading it.

thanks,

greg k-h
