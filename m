Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab0KQFd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:33:56 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:55123 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0KQFdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:33:55 -0500
Date: Wed, 17 Nov 2010 07:32:51 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>,
        Indan Zupancic <indan@nul.nu>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101117053251.GA26928@jasper.tkos.co.il>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
 <4CE0FE71.6000303@suse.cz>
 <20101115100838.GA3649@jasper.tkos.co.il>
 <4CE10B32.8090705@suse.cz>
 <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
 <20101116110444.2f0cabd9@lxorguk.ukuu.org.uk>
 <4CE28299.30907@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE28299.30907@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Alan,

On Tue, Nov 16, 2010 at 02:09:45PM +0100, Jiri Slaby wrote:
> On 11/16/2010 12:04 PM, Alan Cox wrote:
> > Sixteen devices is way too many for drivers/misc - it only has 256 total
> > and only half of those are dynamic.
> 
> Seconded. (And it's a quarter, not even a half like I already wrote.)

If I reduce the maximal number of devices to 4, will it make any difference? I 
don't mind even having a limit of 2 by default, as long as a simple define 
change is enough to raise this limit.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
