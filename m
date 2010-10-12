Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0JLJfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:35:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:37366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab0JLJfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:35:08 -0400
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: William Pitcock <nenolod@dereferenced.org>, linux-kernel@vger.kernel.org,
        efault@gmx.de, kernel@kolivas.org
In-Reply-To: <20101012093044.GD20366@elte.hu>
References: <20101012092524.F0BF4CE142@carpathia.dereferenced.org>
	 <20101012093044.GD20366@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 11:35:01 +0200
Message-ID: <1286876101.29097.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 11:30 +0200, Ingo Molnar wrote:
> * William Pitcock <nenolod@dereferenced.org> wrote:
> 
> > Inspired by the recent change to BFS by Con Kolivas, this patch causes 
> > vruntime to be penalized based on parent depth from their root task 
> > group.
> > 
> > I have, for the moment, decided to make it a default feature since the 
> > design of CFS ensures that broken applications depending on task 
> > enqueue behaviour behaving traditionally will continue to work.
> 
> Just curious, is this v5 submission a reply to Peter's earlier review of 
> your v3 patch? If yes then please explicitly outline the changes you did 
> so that Peter and others do not have to guess about the direction your 
> work is taking.

Going by the date field in the headers he send them all in relatively
quick succession, they just took their merry time arriving (either that
or his machine's time is funkeh).


