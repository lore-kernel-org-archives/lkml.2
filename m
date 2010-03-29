Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0C2JCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:02:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49537 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab0C2JB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:01:58 -0400
Date: Mon, 29 Mar 2010 11:01:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH] x86: mce: Xeon75xx specific interface to get corrected memory error information v2
Message-ID: <20100329090156.GE20695@one.firstfloor.org>
References: <20100324054044.GA4307@basil.fritz.box> <87vdcf7ent.fsf@basil.nowhere.org> <4BB06500.5060105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB06500.5060105@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Xeon 75xx doesn't log physical addresses on corrected machine check
> >> events in the standard architectural MSRs. Instead the address has to
> >> be retrieved in a model specific way. This makes it impossible
> >> to do predictive failure analysis.
> 
> Could you point proper specification or datasheet to know/check what
> you are going to do here?

You mean how the model specific interface works?

There's currently no public specification for the interface,
but it should be reasonably clear from reading the driver how
it works.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
