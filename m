Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab0KPHl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:41:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:41019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0KPHl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:41:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,204,1288594800"; 
   d="scan'208";a="858022744"
Date: Tue, 16 Nov 2010 14:21:28 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2,5/8] NUMA Hotplug emulator
Message-ID: <20101116062128.GB21317@shaohui>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
	linux-kernel@vger.kernel.org
References: <20101116041330.GA20694@shaohui>
 <20101116054747.GA1064@linux-sh.org>
 <A24AE1FFE7AEC5489F83450EE98351BF27D53BCC36@shsmsx502.ccr.corp.intel.com>
 <20101116050507.GA21317@shaohui>
 <20101116070421.GB1330@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116070421.GB1330@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps the easiest is just to insert my patch in to your series as a
> standalone thing and then build on top of it for your patches 4 and 5. If
> you wish to do this, then you can of course add my Signed-off-by for
> that.
> 
> Also, are you doing this development in a git tree somewhere? I'd like to
> get it going on top of SH also, so it would be nice to have a point of
> reference for keeping things in sync (otherwise I'll just make a topic
> branch with your newest version and send you updates incrementally). 

It is an internal project, so we did not have a public git tree. it is available
in internal only.

the purpose of the emulator is just for CPU/Memory hotplug debuging, there are 
a lot of hotplug issues before linux kernel 2.6.32, it is very hard to debug.
With the help of emuatlor, we get them fixed, so we think the emulator is a good
tool, and we want to share it with more people.

-- 
Thanks & Regards,
Shaohui

