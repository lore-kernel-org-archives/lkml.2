Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab2LAA0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:26:42 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50954 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2LAA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:26:38 -0500
Date: Sat, 1 Dec 2012 09:26:35 +0900
From: Simon Horman <horms@verge.net.au>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Message-ID: <20121201002632.GA4416@verge.net.au>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <1349195816-2225-2-git-send-email-arnd@arndb.de>
 <20121003003759.GD31207@verge.net.au>
 <201210040834.55096.arnd@arndb.de>
 <20121004085857.GA7240@verge.net.au>
 <CAOesGMg6afPjBc82FEOwzwn-nBAFPY7K_udJRJO1bBrtCk3Yvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMg6afPjBc82FEOwzwn-nBAFPY7K_udJRJO1bBrtCk3Yvg@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 02:10:47PM -0800, Olof Johansson wrote:
> Hi,
> 
> On Thu, Oct 4, 2012 at 1:58 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Thu, Oct 04, 2012 at 08:34:54AM +0000, Arnd Bergmann wrote:
> >> On Wednesday 03 October 2012, Simon Horman wrote:
> >> > I looked through my fines and found a config that I believe
> >> > worked with a derivative of 2.6.35.7.
> >> >
> >> > It has CONFIG_MEMORY_SIZE=0x1e800000.
> >> >
> >> > So what I suspect has happened is that an extra zero has crept into
> >> > arch/arm/configs/kota2_defconfig and the intended value is:
> >> >
> >> > CONFIG_MEMORY_SIZE=0x1e000000
> >> >
> >> > Unfortunately I do not have access to a board to test this,
> >> > nor am I aware of anyone who does.
> >>
> >> Ok, I'll drop this patch for now then, so we keep the warning around
> >> to remind us of the problem.
> >
> > Thanks. I have subsequently located a Kota2 board,
> > however it may be a little while before I get my hands on it.
> 
> Gentle ping. I just came across this warning again so I figured I'd check.

Sorry, I still don't have a kota2 board.
However, I expect to obtain one within the next week.
