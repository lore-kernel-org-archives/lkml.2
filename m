Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1KIJiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:38:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:55695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1KIJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:38:19 -0500
Message-ID: <4EBA49FF.4090904@infradead.org>
Date: Wed, 09 Nov 2011 07:38:07 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm tree with the v4l-dvb tree
References: <20111109135353.69057bcd2463a6ea009b898e@canb.auug.org.au>
In-Reply-To: <20111109135353.69057bcd2463a6ea009b898e@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-11-2011 00:53, Stephen Rothwell escreveu:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict between commit
> "poll: add poll_requested_events() function" the v4l-dvb and akpm trees.
> It was very similar (but not identical), so I dropeed it from the akpm
> tree.

Hans,

Could you please double-check the differences?

> BTW Mauro, that commit in v4l-dvb comes from a branch that contains a
> series of patches that have various Signed-off-by's but not yours ... it
> looks like they were imported from patchwork, but you forgot to add your
> SOB line.

Stephen,

Thanks for noticing it. Yes, I forgot to add my SOB on those patches, when
importing from Hans tree. I'll fix it for tomorrow's merge.

Thanks!
Mauro

