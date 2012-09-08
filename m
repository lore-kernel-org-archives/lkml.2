Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2IHRvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:51:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57757 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2IHRvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:51:06 -0400
Date: Sat, 8 Sep 2012 10:51:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
Message-ID: <20120908175102.GG10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
 <20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
 <20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 10:50:07AM -0700, Tejun Heo wrote:
> Please create two patches, first introducing pool->manager_mutex and

                                               ^ pool->manager

-- 
tejun
