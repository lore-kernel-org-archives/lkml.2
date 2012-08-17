Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2HQNT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:19:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39981 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2HQNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:19:50 -0400
Date: Fri, 17 Aug 2012 06:19:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/vme: fix checkpatch warning
Message-ID: <20120817131941.GA25079@kroah.com>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
 <1345179920-8303-1-git-send-email-yamanetoshi@gmail.com>
 <20120817074644.GL4559@mwanda>
 <CAOTypNS_rbQK2rPDWenFahiz5Z+cufPTjRy-aABqW01c3DWmYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOTypNS_rbQK2rPDWenFahiz5Z+cufPTjRy-aABqW01c3DWmYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 05:27:53PM +0900, Toshiaki Yamane wrote:
> On Fri, Aug 17, 2012 at 4:46 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > You've got the same subject repeated 5 times.
> >
> > It would be better to merge all the vme_user.c printk fixes into
> > one patch.
> > [patch 1/3] Staging: vme: Fix a white space issue
> > [patch 2/3] Staging: vme: Use pr_ printks in vme_user.c
> > [patch 3/3] Staging: vme: Use pr_ printks in vme_pio2_core.c
> >
> > It's not a huge deal, it just seems like there was some confusion on
> > how to break patches up.
> 
> 
> Thanks for your reply!
> I will try to fix it.

Please do, I can't take it as-is.

greg k-h
