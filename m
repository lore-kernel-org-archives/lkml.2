Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2ISSei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:34:38 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:53040 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2ISSeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:34:36 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoepAFoPWlBV5h1yPGdsb2JhbABFhSGFI7B5AQF/GQEBAQEfGQ0ngiABAQU6HCMQCAMYLhQlChoth227IBSLCBqBOmyDIWADlWOBFYRbjRqBYQ
X-IronPort-AV: E=Sophos;i="4.80,450,1344204000"; 
   d="scan'208";a="117968998"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 19 Sep 2012 20:34:36 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Input and HID updates for 3.7, version 4
Message-ID: <20120919183436.GA764@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <20120910190226.GA877@polaris.bitmath.org>
 <alpine.LNX.2.00.1209102248250.22683@pobox.suse.cz>
 <5556929.93aC5q4087@dtor-d630.eng.vmware.com>
 <20120914192554.GA6498@polaris.bitmath.org>
 <20120915153323.GA1391@polaris.bitmath.org>
 <alpine.LNX.2.00.1209181328500.31149@pobox.suse.cz>
 <20120918161956.GA1539@polaris.bitmath.org>
 <20120919165706.GA16286@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919165706.GA16286@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 09:57:07AM -0700, Dmitry Torokhov wrote:
> On Tue, Sep 18, 2012 at 06:19:56PM +0200, Henrik Rydberg wrote:
> > On Tue, Sep 18, 2012 at 01:29:29PM +0200, Jiri Kosina wrote:
> > > On Sat, 15 Sep 2012, Henrik Rydberg wrote:
> > > 
> > > > Ok, here is version 4 of the patchset. Rather than sending out all the
> > > > patches again, the diff to linux-next is given below, and the
> > > > refreshed tree can be pulled from
> > > > 
> > > >   git://github.com/rydberg/linux.git maybe
> > > > 
> > > > All Dmitry's comments are addressed. Changes in short:
> > > > 
> > > > * Also move 'slot' to input_mt
> > > > * Oops fix amended
> > > > * New patch to allow driver pressure handling
> > > > * Keep the synaptics specials in bcm5974
> > > > 
> > > > Needless to say, I want to move this tree to linux-next soonish, so if
> > > > there are more comments coming, I would appreciate a heads-up.
> > > 
> > > So if Dmitry has Acked all the input patches and I am going to take it, 
> > > could you please send me either a proper pull request, or the patch series 
> > > via e-mail, so that I could apply it?
> > 
> > Absolutely, a pull request is the plan, but I have not heard anything
> > from Dmitry yet. Dmitry, no news is good news?
> 
> Yep, and sorry for the delay.

Thanks, Dmitry. I will send out a pull request shortly.

Henrik
