Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0EOQMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 12:12:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:49783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0EOQMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 12:12:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,236,1272870000"; 
   d="scan'208";a="798739484"
Date: Sun, 16 May 2010 00:08:05 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC,2/7] NUMA Hotplug emulator
Message-ID: <20100515160805.GA23630@shaohui>
Mail-Followup-To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
	David Rientjes <rientjes@google.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Lee Schermerhorn <lee.schermerhorn@hp.com>,
	linux-kernel@vger.kernel.org, ak@linux.intel.co,
	fengguang.wu@intel.com, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com
References: <20100513114544.GC2169@shaohui>
 <AANLkTikZiRw2w9hveCxA2XQp8SYs-4rYpH4BdZOns2CS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikZiRw2w9hveCxA2XQp8SYs-4rYpH4BdZOns2CS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 06:47:00PM +0530, Jaswinder Singh Rajput wrote:
> > +       if (hidden_num)
> 
> if (hidden_num) is not required, as next line's for statement is also
> doing the same thing.

Good catching, We will remove this statement in the formal patch. Thanks Jaswinder.

Have a nice day.

> 
> Thanks,
> --
> Jaswinder Singh.
> 
> > +               for (i = 0; i < hidden_num; i++) {
> > +                       int nid = num_nodes + i + 1;
> > +                       node_set(nid, node_possible_map);
> > +                       hidden_nodes[nid].start = hp_start + hp_size * i;
> > +                       hidden_nodes[nid].end = hp_start + hp_size * (i+1);
> > +                       node_set_hidden(nid);
> > +               }
> > +}

-- 
Thanks & Regards,
Shaohui

