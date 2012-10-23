Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2JWIgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:36:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2JWIgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:36:03 -0400
Date: Tue, 23 Oct 2012 10:35:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, bsingharora@gmail.com
Subject: Re: process hangs on do_exit when oom happens
Message-ID: <20121023083556.GB15397@dhcp22.suse.cz>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
 <20121019160425.GA10175@dhcp22.suse.cz>
 <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-10-12 11:35:52, Qiang Gao wrote:
> I'm sure this is a global-oom,not cgroup-oom. [the dmesg output in the end]

Yes this is the global oom killer because:
> cglimit -M 700M ./tt 
> then after global-oom,the process hangs..

> 179184 pages RAM

So you have ~700M of RAM so the memcg limit is basically pointless as it
cannot be reached...
-- 
Michal Hocko
SUSE Labs
