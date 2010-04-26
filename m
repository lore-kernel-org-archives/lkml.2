Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0DZV4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:56:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48867 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0DZV4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:56:30 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npelly@google.com" <npelly@google.com>,
       "pavan_savoy@yahoo.co.in" <pavan_savoy@yahoo.co.in>
Date: Tue, 27 Apr 2010 03:26:04 +0530
Subject: RE: [PATCH] serial: TTY: new ldiscs for staging
Thread-Topic: [PATCH] serial: TTY: new ldiscs for staging
Thread-Index: Acrlixh5mzpDFjgbSg2tme4O8hA1PwAABXCw
Message-ID: <19F8576C6E063C45BE387C64729E7394044E1EBF9F@dbde02.ent.ti.com>
References: <1270750619-19174-1-git-send-email-pavan_savoy@ti.com>
	<1270750619-19174-2-git-send-email-pavan_savoy@ti.com>
 <20100426225957.532559a2@lxorguk.ukuu.org.uk>
In-Reply-To: <20100426225957.532559a2@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,


> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Monday, April 26, 2010 5:00 PM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; npelly@google.com; pavan_savoy@yahoo.co.in
> Subject: Re: [PATCH] serial: TTY: new ldiscs for staging
> 
> On Thu,  8 Apr 2010 13:16:52 -0500
> pavan_savoy@ti.com wrote:
> 
> > From: Pavan Savoy <pavan_savoy@ti.com>
> >
> > Push the max ldiscs by a few number to allow ldiscs
> > to exist in the staging directory
> >
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > ---
> >  include/linux/tty.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/include/linux/tty.h b/include/linux/tty.h
> > index 4409967..227c0a8 100644
> > --- a/include/linux/tty.h
> > +++ b/include/linux/tty.h
> > @@ -23,7 +23,7 @@
> >   */
> >  #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
> >  #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
> > -#define NR_LDISCS		20
> > +#define NR_LDISCS		25	/* add few ldiscs for staging */
> 
> Doesn't directly apply as NR_LDISCS is now 21 but this should definitely
> go in.


It has I believe, Greg has modified it to 30, and pulled in his tree.
