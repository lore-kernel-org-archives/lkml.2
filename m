Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1KIKFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:05:05 -0500
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1349 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1KIKFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:05:03 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 05:05:02 EST
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the v4l-dvb tree
Date: Wed, 9 Nov 2011 10:54:21 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-durdane; KDE/4.6.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20111109135353.69057bcd2463a6ea009b898e@canb.auug.org.au> <4EBA49FF.4090904@infradead.org>
In-Reply-To: <4EBA49FF.4090904@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111091054.21425.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 09, 2011 10:38:07 Mauro Carvalho Chehab wrote:
> Em 09-11-2011 00:53, Stephen Rothwell escreveu:
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm tree got a conflict between commit
> > "poll: add poll_requested_events() function" the v4l-dvb and akpm trees.
> > It was very similar (but not identical), so I dropeed it from the akpm
> > tree.
> 
> Hans,
> 
> Could you please double-check the differences?

The akpm version was slightly older. The version in linux-next contains a
coding style fix and adds a comment block to the header based on feedback I
received from Andrew.

Regards,

	Hans

> 
> > BTW Mauro, that commit in v4l-dvb comes from a branch that contains a
> > series of patches that have various Signed-off-by's but not yours ... it
> > looks like they were imported from patchwork, but you forgot to add your
> > SOB line.
> 
> Stephen,
> 
> Thanks for noticing it. Yes, I forgot to add my SOB on those patches, when
> importing from Hans tree. I'll fix it for tomorrow's merge.
> 
> Thanks!
> Mauro
> 
