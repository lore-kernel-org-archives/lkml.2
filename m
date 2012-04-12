Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527Ab2DLAaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:30:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46431 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab2DLAaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:30:16 -0400
X-Sasl-enc: bYMcR1YsjbiRl5HiB0oE9KP7JWwBd2jbY1UkjuFAPGN2 1334190615
Date: Wed, 11 Apr 2012 17:30:14 -0700
From: Greg Kroah-Hartman <gregkh@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120412003014.GB23167@kroah.com>
References: <4F80892A.7050104@zytor.com>
 <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com>
 <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com>
 <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com>
 <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120411235311.GA11310@kroah.com>
 <4F8619FD.1080402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8619FD.1080402@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 04:55:41PM -0700, H. Peter Anvin wrote:
> On 04/11/2012 04:53 PM, Greg Kroah-Hartman wrote:
> > 
> > That all seems pretty simple.
> > 
> >>   - get rid of the (rather broken) idea of 'legacy' vs 'non-legacy mode'
> >>     mount options in the default setup; I don't think userspace should
> >>     ever be required to fiddle with such stuff
> > 
> > Hm, but if we get rid of them, what about tools that expect them to be
> > there?  Just silently ignore them?
> > 
> 
> Drop the newinstance mount option on the floor; keep recognizing the
> ptmxmode mount option but change the default.

Wait, change the default to what?

I think this is going to require a lot of testing :)

greg k-h
