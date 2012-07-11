Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2GKLWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:22:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48581 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2GKLWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAFub=KSx+uU0KMG+cQOgd_y7J3EH7TFNPhCNGLBfDMYQWVxdTg@mail.gmail.com>
References: <20120704153443.4055.53130.stgit@bluebook>
	<20120710131526.e64cf710.akpm@linux-foundation.org>
	<829BE905228AE14A9AE1A46E6F2E371605542A19B8@VA3DIAXVS891.RED001.local>
	<CAFub=KSx+uU0KMG+cQOgd_y7J3EH7TFNPhCNGLBfDMYQWVxdTg@mail.gmail.com>
Date: Wed, 11 Jul 2012 19:22:14 +0800
Message-ID: <CAM_iQpW7ksW7dy=f4JPpEi346i4+r2eGdRZOZxym4QGS6g0n4w@mail.gmail.com>
Subject: Re: [PATCH] kernel: fix mishandling of out of memory in poweroff
From: Cong Wang <xiyou.wangcong@gmail.com>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Scan Subscription <scan-subscription@coverity.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I can't find Alan's initial email, so reply to this one.)

Hi, Alan,

I sent a same patch few minutes ahead of yours:

http://marc.info/?l=linux-kernel&m=134137296531838

and got some ACK's already.
