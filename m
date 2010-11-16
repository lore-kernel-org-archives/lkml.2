Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0KPFsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:48:22 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57817 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0KPFsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:48:21 -0500
Date: Tue, 16 Nov 2010 14:47:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Shaohui Zheng <shaohui.zheng@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2,5/8] NUMA Hotplug emulator
Message-ID: <20101116054747.GA1064@linux-sh.org>
References: <20101116041330.GA20694@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116041330.GA20694@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 12:13:30PM +0800, Shaohui Zheng wrote:
> >This looks like an incredibly painful interface. How about scrapping all
> >of this _emu() mess and just reworking the register_cpu() interface?
> > Something like:
> 
> hi, Paul
> 	I saw your reply on patchwork.kernel.org, but I did not find your email 
> in my mailbox, you might forget to cc to me.
> 
Then fix your mailer. You are presently forcing Mail-Followup-To to the
list, which in turn is dropping you from the cc on a group reply.

> 	I think that your register_cpu_node interface seems good, but this will 
> remove the interface register_cpu. it is not the original purpose of the 
> emulator, we want to emulate the oringal process, but we did not want to change
> the old interface, that is a rule.
> 
Wait, what? How does my patch remove register_cpu()? It does no such
thing, all it does is add a supplemental register_cpu_node() for you to
call in to, without needing to carry any of the _emu() damage around. The
old interface has not been modified in any way whatsoever.
