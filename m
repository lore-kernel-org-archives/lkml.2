Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2EJVHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:07:38 -0400
Received: from bsmtp5.bon.at ([195.3.86.187]:13416 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754161Ab2EJVHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:07:36 -0400
X-Greylist: delayed 1439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 17:07:36 EDT
From: Markus Grabner <grabner@icg.tugraz.at>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Johannes Thumshirn <morbidrsa@googlemail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, andor.daam@googlemail.com,
        thomas@m3y3r.de, jj@chaosbits.net, stefanha@gmail.com
Subject: Re: [PATCH] drivers/staging/line6/config.h: Remove CHECKPOINT macro
Date: Thu, 10 May 2012 22:43:12 +0200
Message-ID: <3216742.sbGdhqZvbl@mark>
Organization: Graz University of Technology
User-Agent: KMail/4.8.3 (Linux/3.1.10-1.9-desktop; KDE/4.8.3; x86_64; ; )
In-Reply-To: <20120510164953.GA32245@kroah.com>
References: <1336415273-11713-1-git-send-email-morbidrsa@googlemail.com> <1336667410-10035-1-git-send-email-morbidrsa@googlemail.com> <20120510164953.GA32245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012 09:49:53 Greg KH wrote:
> On Thu, May 10, 2012 at 06:30:10PM +0200, Johannes Thumshirn wrote:
> > Kill unused debugging macro CHECKPOINT
> > ---
> > 
> >  drivers/staging/line6/config.h |    5 -----
> >  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> -ENOSIGNED_OFF_BY_LINE :(
The file "config.h" can be removed altogether, it is not included by any other 
file in the Line6 USB driver.

	Kind regards,
		Markus


-- 
Markus Grabner
Institute for Computer Graphics and Vision
Graz University of Technology, Inffeldgasse 16a/II, 8010 Graz, Austria
WWW: http://www.icg.tugraz.at/Members/grabner

