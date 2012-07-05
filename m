Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2GEXIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:08:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36892 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab2GEXIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:08:47 -0400
Date: Thu, 5 Jul 2012 16:08:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>,
        "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        Imran Ansari <imran@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        mcgrof@frijolero.org, hauke@hauke-m.de, ozancag@gmail.com,
        pstew@google.com, warthog9@kernel.org, jrnieder@gmail.com,
        ben@decadent.org.uk, akpm@linux-foundation.org, linville@tuxdriver.com
Subject: Re: 3.5 stable compat-wireless
Message-ID: <20120705230842.GA26510@kroah.com>
References: <20468.35601.132955.802881@gargle.gargle.HOWL>
 <7A9ADFFA56024346AAE90B6BABC3BD15DD6DEB@NASANEXD02B.na.qualcomm.com>
 <20469.13787.767293.602337@gargle.gargle.HOWL>
 <20120705190801.GB11228@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705190801.GB11228@tux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 12:08:01PM -0700, Luis R. Rodriguez wrote:
>   * linux-crap.git: based on linux-next-pending.git and allows
>     contributors to send pull requests of crap that is not *ready*
>     to be sent properly upstream. Examples would be code we know
>     we simply already know that is not dealing with proper architecture
>     or style / etc. The drivers/staging/ allows vendors to post full
>     crap drivers, this would enable us to merge crap patches but that
>     some vendors might need / want.

I really doubt this will work, look at the patches in some distros for
examples of why.  I'm having a hard enough time with the LTSI project in
conveying that "Yes, you can send patches to me for merging into the
LSTI kernel, you still have to justify it, and work to get the patches
then upstream, I'm not going to do your work for you."

Having a random tree where these patches show up help no one except the
original developer so that they can fire-and-forget, which is not what
you want, unless you wish to take on the "get it cleaned up and merged
upstream" task yourself, which you really don't want to.

good luck,

greg k-h
