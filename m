Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1KQJCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:02:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1KQJC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:02:26 -0500
Subject: Re: [PATCH 2/2] lockdep: print lock name for lockdep_init_error
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Nov 2011 10:01:59 +0100
In-Reply-To: <20111117084435.GA16757@zhy>
References: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
	 <1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
	 <20111117060215.GB15644@zhy>
	 <CACVXFVPo410dy5Mz_Kd3vC=iLazgg8MuPpHnMKfUbUypfXaGUg@mail.gmail.com>
	 <20111117084435.GA16757@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321520520.27735.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:44 +0800, Yong Zhang wrote:
> On Thu, Nov 17, 2011 at 04:01:16PM +0800, Ming Lei wrote:

> To me that still means 'Arch code didn't call lockdep_init()
> early enough'.
> 
> But anyway, let Peter/Ingo decide it.

I kinda like the hint as to what might have ran too early, so I've
queued it.
