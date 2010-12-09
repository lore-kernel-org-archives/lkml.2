Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0LIUNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:13:46 -0500
Received: from kroah.org ([198.145.64.141]:56090 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935Ab0LIUNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:13:45 -0500
Date: Thu, 9 Dec 2010 12:13:35 -0800
From: Greg KH <greg@kroah.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, lkml20101129@newton.leun.net,
        netdev@vger.kernel.org, jesse@nicira.com, linux-kernel@vger.kernel.org,
        greearb@candelatech.com, stable@kernel.org
Subject: Re: [stable] [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when
 vid not used
Message-ID: <20101209201335.GB28159@kroah.com>
References: <1291108809.2904.3.camel@edumazet-laptop>
 <20101201111716.424fb771@xenia.leun.net>
 <1291200914.2856.546.camel@edumazet-laptop>
 <20101208.084731.189716071.davem@davemloft.net>
 <20101208231624.GA8992@kroah.com>
 <1291857933.2795.7.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291857933.2795.7.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:25:33AM +0100, Eric Dumazet wrote:
> Le mercredi 08 décembre 2010 à 15:16 -0800, Greg KH a écrit :
> > On Wed, Dec 08, 2010 at 08:47:31AM -0800, David Miller wrote:
> > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > Date: Wed, 01 Dec 2010 11:55:14 +0100
> > > 
> > > 
> > > Greg/-stable, please integrate this patch from Eric into 2.6.36 if you
> > > haven't already done so.
> > 
> > I've updated the version in the .36-stable queue with this one, thanks.
> > 
> 
> Thanks.
> 
> By the way, all credits given to Jesse, I only made a change to his
> patch, so I left him as the author.
> 
> Ah I see I forgot the "From: Jesse Gross <jesse@nicira.com>" header when
> I sent it, my bad, sorry !

No problem, I have that in the patch header already :)

thanks,

greg k-h
