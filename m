Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab0HEULA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:11:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab0HEUK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:10:59 -0400
From: Thomas Renninger <trenn@suse.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Dynamic Debug: Introduce global fake module param module.ddebug
Date: Thu, 5 Aug 2010 22:11:18 +0200
User-Agent: KMail/1.9.10
Cc: Jason Baron <jbaron@redhat.com>, yehuda@hq.newdream.net,
        LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
References: <201007261414.30718.trenn@suse.de> <201008051805.40730.trenn@suse.de> <20100805172554.GA12234@kroah.com>
In-Reply-To: <20100805172554.GA12234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008052211.18666.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 August 2010 07:25:54 pm Greg KH wrote:
> On Thu, Aug 05, 2010 at 06:05:40PM +0200, Thomas Renninger wrote:
> > On Thursday 05 August 2010 17:39:10 Jason Baron wrote:
...
> > So, I have your acked-by for this one?
> > Let's get this pushed into a tree, with some luck it still could make it
> > into 2.6.36? The other three have been taken by Pekka? He said something
> > about taking them, but I haven't received any confirmation.
> > Ah no, he acked-by them only.
>
> It's too late for .36 as none of this has been tested in linux-next yet.
> How about for .37?
No problem. I send you a clean patchset tomorrow.
I have one additional idea I'll try to build in:
Complain if a module uses ddebug as module parameter at module
insertion time that this is a reserved keyword/param that must not be used.

I'll leave out lkml, Andrew and Pekka (I thought they could queue these).

Thanks everybody,

     Thomas
