Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab1EXVdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:33:12 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:56320 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab1EXVdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:33:10 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 24 May 2011 22:33:08 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110524155007.GB29481@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <20110524155007.GB29481@dumpdata.com>
Message-ID: <1748634cd0eef25a5edea99e1953fe65@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not bug per say. I've been working on making the TTM use the DMA API
> so that those pages are allocated at startup and you don't end up
> with having to sync the pages .. but I broke PowerPC and ARM during 
> 2.6.39
> so I need to redo it.

 If this is not a bug, shouldn't there be a message like
 "radeon currently does not work with SWIOTLB, disabling..."
 instead of
 "ring test failed, disabling..."?
