Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2LJLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:49:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60581 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377Ab2LJLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:49:47 -0500
Message-ID: <1355140186.26815.6.camel@joe-AO722>
Subject: Re: [PATCH 5/5] rtl8712: replace leading spaces with tab
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Przemo Firszt <przemo@firszt.eu>, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, greg@kroah.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Dec 2012 03:49:46 -0800
In-Reply-To: <20121210094613.GR6568@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
	 <1355048110-10859-5-git-send-email-przemo@firszt.eu>
	 <20121210094613.GR6568@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 12:46 +0300, Dan Carpenter wrote:
> On Sun, Dec 09, 2012 at 10:15:10AM +0000, Przemo Firszt wrote:
> > Replace leading spaces with tab
[]
> > diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
[]
> >  static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
> > -			    unsigned short ielen)
> > +				unsigned short ielen)
> 
> The original version is better because it lines up correctly.
> 
> Checkpatch doesn't complain for me so I'm not sure what the story is
> here.

Parenthesis alignment isn't described in CodingStyle.
It's maintainer's preference.  Whether or not it should
be is a different question.

checkpatch parenthesis alignment of arguments checks are
emitted only when adding --strict to the command line.


