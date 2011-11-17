Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1KQLpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:45:39 -0500
Received: from haggis.mythic-beasts.com ([93.93.131.52]:56953 "EHLO
	haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab1KQLpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:45:38 -0500
Date: Thu, 17 Nov 2011 11:44:51 +0000
From: Luis Henriques <henrix@camandro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
Message-ID: <20111117114451.GC3762@hades>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
 <20111115084059.GA23250@zhy>
 <20111116091653.GA8692@zhy>
 <1321452758.4181.18.camel@frodo>
 <alpine.LFD.2.02.1111161801270.4902@ionos>
 <20111117030332.GA14492@zhy>
 <alpine.LFD.2.02.1111171125020.4902@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111171125020.4902@ionos>
X-BlackCat-Spam-Score: -10
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 11:25:56AM +0100, Thomas Gleixner wrote:
> Johannes came up with a different solution. Could you please give it a try?

Again, I've run a quick test and it looks like this solves the issue.

Cheers,
--
Luis Henriques
