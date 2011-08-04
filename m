Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1HDPUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:20:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:47452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1HDPUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:20:06 -0400
Subject: Re: Regression in 3.0-git - bisected to commit
 dd4e5d3ac4a76b868daf30e35bd572def96c30ed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4E3AB5E0.5080506@lwfinger.net>
References: <4E3AB5E0.5080506@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Aug 2011 17:19:10 +0200
Message-ID: <1312471150.16729.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 10:08 -0500, Larry Finger wrote:
> The logs for a recent git pull from Linus's tree show the warning below. The 
> problem has been bisected to commit dd4e5d3ac4a7 with the commit message of
> 
> ===============
> lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion

Thanks, but yes that's known, and a patch has been queued for merger
that should solve this:

https://lkml.org/lkml/2011/8/4/60


