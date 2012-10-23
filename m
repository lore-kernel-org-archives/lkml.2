Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2JWJnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:43:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab2JWJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:43:19 -0400
Date: Tue, 23 Oct 2012 11:43:17 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, bsingharora@gmail.com
Subject: Re: process hangs on do_exit when oom happens
Message-ID: <20121023094317.GC15397@dhcp22.suse.cz>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
 <20121019160425.GA10175@dhcp22.suse.cz>
 <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
 <20121023083556.GB15397@dhcp22.suse.cz>
 <CAKWKT+ZG-Rw5spLUdn74H3QQ1RGrax2B4X_ksZB-OCHY5WXC6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKWKT+ZG-Rw5spLUdn74H3QQ1RGrax2B4X_ksZB-OCHY5WXC6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-10-12 17:08:40, Qiang Gao wrote:
> this is just an example to show how to reproduce. actually,the first time I saw
> this situation was on a machine with 288G RAM with many tasks running and
> we limit 30G for each.  but finanlly, no one exceeds this limit the the system
> oom.

Yes but mentioning memory controller then might be misleading... It
seems that the only factor in your load is the cpu controller.

And please stop top-posting. It makes the discussion messy.
-- 
Michal Hocko
SUSE Labs
