Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1EHPdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:33:08 -0400
Received: from kroah.org ([198.145.64.141]:43938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1EHPdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:33:05 -0400
Date: Sun, 8 May 2011 08:31:30 -0700
From: Greg KH <greg@kroah.com>
To: Erik Slagter <erik@slagter.name>
Cc: Maxin John <maxin.john@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: OOPS after connection Droids MuIn USB display
Message-ID: <20110508153130.GA31615@kroah.com>
References: <4DC3B0E3.7010008@slagter.name>
 <4DC3D296.9060707@slagter.name>
 <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
 <4DC42897.3000300@slagter.name>
 <BANLkTinGydyuG58zwVG43VnDz845BOw1Tg@mail.gmail.com>
 <4DC4EE99.1090205@slagter.name>
 <20110507200252.GA19753@kroah.com>
 <4DC64A03.2050107@slagter.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC64A03.2050107@slagter.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 09:45:07AM +0200, Erik Slagter wrote:
> On 07-05-11 22:02, Greg KH wrote:
> >On Sat, May 07, 2011 at 09:02:49AM +0200, Erik Slagter wrote:
> >>And now my big question is, can this be fixed upstream? ;-)
> >
> >Yes, if someone sends us a patch :)
> 
> Somehow I knew where this was going to :-/ I can happily make a
> clean patch that makes this device work, but as I am almost
> completely in the dark as whether what I am doing, it will probably
> break any other device and also fix it in the wrong way as well.
> I've had patches rejected for the same reasons in the past...

Well, try it and we will work at it from there, otherwise nothing will
change.

thanks,

greg k-h
