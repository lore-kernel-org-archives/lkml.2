Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0JYLPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:15:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47161 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0JYLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:15:08 -0400
Date: Mon, 25 Oct 2010 09:15:30 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Greg KH <greg@kroah.com>
Cc: linux-bluetooth@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Bluetooth: fix crash in L2CAP
Message-ID: <20101025111530.GC7721@vigoh>
References: <1287638393-8573-1-git-send-email-padovan@profusion.mobi>
 <20101021133507.GB20184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021133507.GB20184@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

* Greg KH <greg@kroah.com> [2010-10-21 06:35:07 -0700]:

> On Thu, Oct 21, 2010 at 03:19:52AM -0200, Gustavo F. Padovan wrote:
> > Hi Greg,
> > 
> > The following patch is good for 2.6.36.1. It arrived too late in linux-bluetooth
> > and we didn't had time to put it into 2.6.36. It fixes a serious crash into
> > the L2CAP layer. The issue isn't in 2.6.35 and below.
> 
> It needs to get into Linus's tree before I can accept it into the
> -stable trees.  Please get it there and then send stable@kernel.org the
> git commit id and I will add it.

It is now on Linus' tree, sorry for doing this wrong first time. It was
my first report to stable. ;)

commit d793fe8caa3911e6a1e826b45d4ee00d250cdec8

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
