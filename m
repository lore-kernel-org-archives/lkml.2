Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0LaJL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 04:11:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0LaJLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 04:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=J/dM1loixobuOBLYDlTO3tRxUzjbESyfbv4aLe/y/ZLFXjeQg9YOaXIAcG3Xyp4YQy
         jb0fl3cqLpHr/eLPUf82u9UxmzNeQsrGAYiq2ux8MkoKKhDQPsBWQwUmclNTovc1zm59
         X7aBWy8ux4vPgZPJfZKx8pr4wWrxljy+3DuN8=
Date: Fri, 31 Dec 2010 12:11:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-m68k@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to
 disable.
Message-ID: <20101231091136.GC1886@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
	devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-m68k@lists.linux-m68k.org,
	spi-devel-general@lists.sourceforge.net,
	linux-media@vger.kernel.org
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <20101231064515.GC3733@angua.secretlab.ca>
 <4D1D7DAE.7060504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1D7DAE.7060504@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 10:52:30PM -0800, Justin P. Mattock wrote:
> On 12/30/2010 10:45 PM, Grant Likely wrote:
> >On Thu, Dec 30, 2010 at 03:07:51PM -0800, Justin P. Mattock wrote:
> >>The below patch fixes a typo "diable" to "disable". Please let me know if this
> >>is correct or not.
> >>
> >>Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> >
> >applied, thanks.
> >
> >g.
> 
> ahh.. thanks.. just cleared up the left out diabled that I had
> thought I forgotten(ended up separating comments and code and
> forgot)

This is really just defensiveness and random grumbling and grumpiness on
my part, but one reason I may have missed the first patch is because
your subject lines are crap.

Wrong:  [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.

Right:  [PATCH 02/15] spi/dw_spi: Typo change diable to disable

regards,
dan carpenter
