Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1LFSmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:42:31 -0500
Received: from kanga.kvack.org ([205.233.56.17]:42844 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1LFSma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:42:30 -0500
Date: Tue, 6 Dec 2011 13:42:29 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Damien Millescamps <damien.millescamps@6wind.com>
Cc: netdev@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: v6: faster tree-based sysctl implementation
Message-ID: <20111206184229.GD22987@kvack.org>
References: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com> <CAJL_dMtgP+BqFn3aGVBbGDJ+kMyGiEC_NmDURzh4mU=Jo=qZVA@mail.gmail.com> <CAPLs8y8vhioqc3CPrD7ugmVkR2DjKWNm8+T5j9QQnrxi=BgvdA@mail.gmail.com> <4EDE470D.3070808@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDE470D.3070808@6wind.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 05:47:09PM +0100, Damien Millescamps wrote:
> A use-case for wanting to be able to create several interfaces is to 
> have a "tunnel" server handling several dynamic point to point connections.

I can chime in that this is also an issue for edge routers terminating 
lots of PPPoE, L2TP or even DHCP sessions.  Interfaces numbering in the 
thousands or tens of thousands are common for 1G or 10G worth of bandwidth 
aggregation.

		-ben
-- 
"Thought is the essence of where you are now."
