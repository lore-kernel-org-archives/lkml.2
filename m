Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0KQFt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:49:29 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:55250 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0KQFt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:49:28 -0500
Date: Wed, 17 Nov 2010 07:48:57 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>, Indan Zupancic <indan@nul.nu>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101117054857.GB26928@jasper.tkos.co.il>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
 <4CE0FE71.6000303@suse.cz>
 <20101115100838.GA3649@jasper.tkos.co.il>
 <4CE10B32.8090705@suse.cz>
 <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
 <20101116110444.2f0cabd9@lxorguk.ukuu.org.uk>
 <4CE28299.30907@suse.cz>
 <20101117053251.GA26928@jasper.tkos.co.il>
 <4CE36B8B.3040403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE36B8B.3040403@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H. Peter,

On Tue, Nov 16, 2010 at 09:43:39PM -0800, H. Peter Anvin wrote:
> On 11/16/2010 09:32 PM, Baruch Siach wrote:
> > On Tue, Nov 16, 2010 at 02:09:45PM +0100, Jiri Slaby wrote:
> >> On 11/16/2010 12:04 PM, Alan Cox wrote:
> >>> Sixteen devices is way too many for drivers/misc - it only has 256 total
> >>> and only half of those are dynamic.
> >>
> >> Seconded. (And it's a quarter, not even a half like I already wrote.)
> > 
> > If I reduce the maximal number of devices to 4, will it make any difference? I 
> > don't mind even having a limit of 2 by default, as long as a simple define 
> > change is enough to raise this limit.
> > 
> Just use a major.  No biggie.

And create my own 'struct class'?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
