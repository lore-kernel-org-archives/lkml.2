Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1DMICO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:02:14 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:56583 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1DMICK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:02:10 -0400
Date: Wed, 13 Apr 2011 10:02:04 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110413080204.GA3871@iram.es>
References: <20110404235259.GA30132@iram.es> <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com> <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local> <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local> <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302608770.27054.36.camel@thor.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 01:46:10PM +0200, Michel Dänzer wrote:
> BTW, if your kernel contains commit
> 69a07f0b117a40fcc1a479358d8e1f41793617f2, can you try if reverting that
> helps?

My kernel is pristine 2.6.38 and does not include this commit
(was introduced before 2.6.39-rc1 according to gitk).

	Gabriel
