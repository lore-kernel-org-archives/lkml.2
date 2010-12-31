Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0LaPGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:06:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0LaPGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:06:16 -0500
Subject: Re: [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to
 disable.
From: James Bottomley <James.Bottomley@suse.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-m68k@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-media@vger.kernel.org
In-Reply-To: <4D1DE616.7010105@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
	 <20101231064515.GC3733@angua.secretlab.ca> <4D1D7DAE.7060504@gmail.com>
	 <20101231091136.GC1886@bicker>  <4D1DE616.7010105@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 09:06:08 -0600
Message-ID: <1293807968.3085.1.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 06:17 -0800, Justin P. Mattock wrote:
> On 12/31/2010 01:11 AM, Dan Carpenter wrote:
> > On Thu, Dec 30, 2010 at 10:52:30PM -0800, Justin P. Mattock wrote:
> >> On 12/30/2010 10:45 PM, Grant Likely wrote:
> >>> On Thu, Dec 30, 2010 at 03:07:51PM -0800, Justin P. Mattock wrote:
> >>>> The below patch fixes a typo "diable" to "disable". Please let me know if this
> >>>> is correct or not.
> >>>>
> >>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> >>>
> >>> applied, thanks.
> >>>
> >>> g.
> >>
> >> ahh.. thanks.. just cleared up the left out diabled that I had
> >> thought I forgotten(ended up separating comments and code and
> >> forgot)
> >
> > This is really just defensiveness and random grumbling and grumpiness on
> > my part, but one reason I may have missed the first patch is because
> > your subject lines are crap.
> >
> > Wrong:  [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
> >
> > Right:  [PATCH 02/15] spi/dw_spi: Typo change diable to disable
> >
> > regards,
> > dan carpenter
> >
> 
> alright.. so having the backlash is alright for the subject
> 
> Thanks for the pointer on this..

There is actually no specific form.  Most of us edit this part of the
subject line anyway to conform to whatever (nonuniform) conventions we
use.  I just use <component>: with no scsi or drivers prefix because the
git tree is tagged [SCSI]; others are different.

James


