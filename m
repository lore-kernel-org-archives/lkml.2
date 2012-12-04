Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2LDD3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 22:29:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63930 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2LDD3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 22:29:38 -0500
Date: Mon, 3 Dec 2012 19:31:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Peng, Tao" <tao.peng@emc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
Message-ID: <20121204033129.GA4810@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-42-git-send-email-herton.krzesinski@canonical.com>
 <1353983604.4266.44.camel@deadeye.wl.decadent.org.uk>
 <20121130014607.GD13478@kroah.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA90B32EE5D@SACEXCMBX04-PRD.hq.netapp.com>
 <1882637210201641A747464075FFC649037C07@MX101CL02.corp.emc.com>
 <1882637210201641A747464075FFC64903815F@MX101CL02.corp.emc.com>
 <1882637210201641A747464075FFC649038FA5@MX101CL02.corp.emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1882637210201641A747464075FFC649038FA5@MX101CL02.corp.emc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 02:55:14AM +0000, Peng, Tao wrote:
> > -----Original Message-----
> > From: Peng, Tao
> > Sent: Saturday, December 01, 2012 11:47 PM
> > To: Myklebust, Trond; Greg Kroah-Hartman; Ben Hutchings
> > Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; kernel-team@lists.ubuntu.com; Herton Ronaldo
> > Krzesinski
> > Subject: RE: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
> > 
> > Hi Greg and Ben,
> > 
> > Attached is the patch of upstream commit fe6e1e8d9fad86873eb74a26e80a8f91f9e870b5 backported to 3.4.20
> > stable branch (head 0f4475cfaaf80e34ea5496a93ce579fe8c6950d5).
> > 
> Hi Greg,
> 
> Somehow the patch got dropped? I just scanned through the newly
> released 3.4.21 and it doesn't have the patch.

Yes, because it came after I started the -rc cycle, it will be in the
next 3.4-stable release.

thanks,

greg k-h
