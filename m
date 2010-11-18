Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0KRRXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:23:44 -0500
Received: from mail.vyatta.com ([76.74.103.46]:53034 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab0KRRXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:23:42 -0500
Date: Thu, 18 Nov 2010 09:23:37 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101118092337.370449e1@nehalam>
In-Reply-To: <AANLkTing6JkfH=n2GfWtW+2=5oB40FDM-TYPvzd+PPkH@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
	<20101118164552.GC2855@kroah.com>
	<AANLkTing6JkfH=n2GfWtW+2=5oB40FDM-TYPvzd+PPkH@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 08:53:22 -0800
"Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:

> On Thu, Nov 18, 2010 at 8:45 AM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Nov 18, 2010 at 12:46:37AM -0800, Luis R. Rodriguez wrote:
> >> Can Linux help in any way? What if we used staging for a common driver
> >> architecture for different OSes? Most of those staging drivers already
> >> have some sort of OS agnostic cruft, why not try to help hardware
> >> vendors by providing them with a common OS agnostic solution they can
> >> share? Is this not out turf? If its not, are we perfectly OK in being
> >> second citizens so long as the driver eventually gets done on proper
> >> upstream Linux ? I'm not OK with it and hence my e-mail. I'm looking
> >> for ideas and thoughts on this. Please no trolls, would really just
> >> like some constructive discussions on this. As I see it maybe we can
> >> move some of this OS agnostic crap into staging, and then use spatch
> >> to write tools to de-unwrap crap to Linux specific stuff and help
> >> maintain it. What this does is it moves OS agnostic crap out as a
> >> community effort to help aid proper development and porting for Linux.
> >> Since we'd maintain the crap / scripts / de-wrappers, we'd likely be
> >> able to get drivers quicker and can have a framework to help companies
> >> who still [1] need to support other Operating Systems.
> >
> > No, staging is for gettingn code into, or out of, the kernel tree, not
> > for anything else.
> >
> > I have allowed it to be used to hold drivers in that are not
> > "acceptable", while another driver was written by others from scratch to
> > work properly on that hardware, and then the original one is dropped.
> > That's ok, as there is a time-limit on how long the code lives in the
> > staging tree.
> >
> > But to try to use it to create a multi-os solution, no, that's not what
> > staging is for.
> 
> OK thanks!
> 
> > Also, please review the past multi-os driver initiatives that have
> > sprung up over the years (about 1 every 10 years it seems).  Please
> > learn from the past as to why those have failed every single time, and
> > why we don't want to even try to do that again.
> 
> :-) thanks, just testing waters to see what's possible and what
> direction to focus more on.
> 
>   Luis

If you go back to the Mythical Man Month you will find:
 "Plan on doing it twice; you are going to anyway"

Therefore I wouldn't worry about whether the first development version
is upstream.

-- 
