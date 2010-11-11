Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0KKMgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:36:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:38365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab0KKMgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:36:04 -0500
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101111100628.GA24728@localhost>
References: <20101111100628.GA24728@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 13:36:18 +0100
Message-ID: <1289478978.2084.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 18:06 +0800, Wu Fengguang wrote:
> 
> I run into this kernel panic since 2.6.27-rc1.  2.6.36 boots OK.
> It's not yet fixed in 2.6.37-rc1-next-20101110. I can conveniently
> test any debug patches.
> 
Happen to have a .config handy? I've never seen this..
