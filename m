Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0DIFWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:22:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0DIFWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:22:36 -0400
Message-ID: <4BBEB995.4090307@infradead.org>
Date: Fri, 09 Apr 2010 02:22:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with Linus' tree
References: <20100407110035.217b024b.sfr@canb.auug.org.au>
In-Reply-To: <20100407110035.217b024b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell wrote:
> Hi Mauro,
> 
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> drivers/media/video/meye.c between commit
> 5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
> and slab.h includes to prepare for breaking implicit slab.h inclusion
> from percpu.h") from Linus' tree and commit
> b214778b09229f9135e715bf346c25f98c8ac1e4 ("V4L/DVB: meye: remove last
> V4L1 remnants from the code and add v4l2_device") from the v4l-dvb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the change
> for a while.

Thanks for pointing it to me. Fixed.

I also fixed today a conflict that it would appear on your next pull, between 
input and v4l-dvb, due to the upstream changes of keytable ops from
int to unsigned.

-- 

Cheers,
Mauro
