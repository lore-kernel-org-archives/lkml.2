Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2LJMV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:21:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34613 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:21:27 -0500
Date: Mon, 10 Dec 2012 15:21:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        Przemo Firszt <przemo@firszt.eu>, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 5/5] rtl8712: replace leading spaces with tab
Message-ID: <20121210122103.GT6568@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
 <1355048110-10859-5-git-send-email-przemo@firszt.eu>
 <20121210094613.GR6568@mwanda>
 <1355140186.26815.6.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355140186.26815.6.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 03:49:46AM -0800, Joe Perches wrote:
> On Mon, 2012-12-10 at 12:46 +0300, Dan Carpenter wrote:
> > On Sun, Dec 09, 2012 at 10:15:10AM +0000, Przemo Firszt wrote:
> > > Replace leading spaces with tab
> []
> > > diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> []
> > >  static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
> > > -			    unsigned short ielen)
> > > +				unsigned short ielen)
> > 
> > The original version is better because it lines up correctly.
> > 
> > Checkpatch doesn't complain for me so I'm not sure what the story is
> > here.
> 
> Parenthesis alignment isn't described in CodingStyle.
> It's maintainer's preference.  Whether or not it should
> be is a different question.
> 
> checkpatch parenthesis alignment of arguments checks are
> emitted only when adding --strict to the command line.
> 

Even with --strict checkpatch.pl is fine with the original code.

I don't know any subsystems where the new version would be prefered
over the original version.

regards,
dan carpenter

