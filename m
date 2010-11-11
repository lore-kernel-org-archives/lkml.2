Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0KKLTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:19:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60162 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0KKLTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:19:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=OAgBdzD5DLhmJ6i4IpOGNaHRvr7+Nb5oxZ9/ucTa/nOvlnYoW9VORgNDgci0sIgNXK
         aa2RHqYdTzxtfYAJbaVlUDkDAjjTJwfvR+C41CGWGFcdMNwUUleDjfbO6HblTEIEFdld
         kJa/Q0kdux4VMXF8a04/My07O7OqHJ1EK+k9M=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Greg KH <greg@kroah.com>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Thu, 11 Nov 2010 12:21:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Roland Dreier <rdreier@cisco.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <adar5esn1gd.fsf@cisco.com> <20101111004730.GC22463@kroah.com>
In-Reply-To: <20101111004730.GC22463@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011111221.09237.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 11 November 2010 01:47:30, Greg KH a écrit :
> On Wed, Nov 10, 2010 at 04:33:38PM -0800, Roland Dreier wrote:
> >  > Isn't the openwrt stuff just drivers and some arch specific code?
> >  > Nothing that is core infrastructure, and nothing preventing them from
> >  > submitting the drivers and arch code if they want to, right?
> > 
> > Actually openwrt has some core infrastructure for managing (ethernet)
> > switches as extra-fancy multiport PHYs.  That means that all the drivers
> > in openwrt for the typical 5-8 port switches in home routers don't
> > really apply to mainline.
> 
> Why can't we merge that core infrastructure as well?  Has it been
> rejected for any specific reasons?

It has been not been submitted for review yet, I suppose we could do that 
within the next couple days.
--
Florian

