Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2ITJI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:08:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2ITJI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:08:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Davicom DM9000C driver
Date: Thu, 20 Sep 2012 09:08:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Allen Huang (=?utf-8?q?=E9=BB=83=E5=81=89=E6=A0=BC?=) 
	<allen_huang@davicom.com.tw>,
        linux-kernel@vger.kernel.org,
        "'Michael Chen'" <michael_chen@mail.davicom.com.tw>,
        "'Charles'" <charles_tsai@davicom.com.tw>,
        "'Joseph Chang'" <joseph_chang@mail.davicom.com.tw>
References: <20120919055333.3ECF95F94D@mail.davicom.com.tw> <20120919173524.7bf4a974@lwn.net>
In-Reply-To: <20120919173524.7bf4a974@lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201209200908.00519.arnd@arndb.de>
X-Provags-ID: V02:K0:DRtOg8kMRe05OCNVKA5b5PvbxuK0uzkfDbQ41FLf1+9
 7EhQYuKGoUIIpn+XBnnbotrIuzLyn3iSx++sE6Om//637CiWEO
 yf+lieAevSAaDLwnW9uTsyxUGGKZJ86S1c1O5Yrfll5wKY2w8s
 PbG+iCNGMUS8uI1mfv/ooS6Ccp6xvraS8wSj/14ma9i9LIJw6b
 qB2Hwwr4RRpo/akjOb8N6CXaqlyrj3d1xBIGTDwCPCiORbMoZ/
 kCbqn9w+mWbJ3EU6r9SVxu/LBSPt5bWpIdihDHJdSwxoqizAyL
 lYpTstd8uxs8Rpyi4YKlhVTcGgOrYh+w3KP1w7ZMqKJvMhcE7y
 WOzpeTn4SVuBUkGfuOs8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2012, Jonathan Corbet wrote:
> On Wed, 19 Sep 2012 13:58:08 +0800
> Allen Huang (黃偉格)  <allen_huang@davicom.com.tw> wrote:
> 
> > I'm Allen Huang from Davicom. We are hereby opensourcing the linux
> > driver for our DM9000C. 
> 
> That is great, but please read the development process documentation on
> how best to submit something like this.  We would much rather see a patch
> (inline, not as an attachment) to facilitate the review.

More importantly, the patch should be against the version that is
already present in the kernel as drivers/net/ethernet/davicom/dm9000.c,
which appears to be mostly the same as the version that is submitted
here.

So while all the comments on the driver are valuable, they also apply
to the code we already have since 2005.

	Arnd
