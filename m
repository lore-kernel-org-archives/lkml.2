Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2EOK2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:28:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:47242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2EOK2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:28:40 -0400
Message-ID: <1337077714.27694.21.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
Date: Tue, 15 May 2012 12:28:34 +0200
In-Reply-To: <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
	 <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
	 <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 12:17 +0300, Pantelis Antoniou wrote:
> IMO this whole idea about 'server' or 'desktop' schedulers is bunk.

Yeah, its complete shite. Everybody cares about throughput, latency and
power. The exact balance might differ between workloads but those cannot
be split between desktop/server at all. Furthermore, nobody wants one at
all costs to the others.
