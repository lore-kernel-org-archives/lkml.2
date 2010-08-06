Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743Ab0HFVTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:19:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0HFVTJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 6 Aug 2010 17:19:09 -0400
Date: Fri, 6 Aug 2010 17:17:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, stefano.stabellini@eu.citrix.com,
        linux-mm@kvack.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, v.tolstov@selfip.ru
Subject: Re: [PATCH] GSoC 2010 - Memory hotplug support for Xen guests -
 second fully working version - once again
Message-ID: <20100806211726.GA18466@phenom.dumpdata.com>
References: <20100806111147.GA31683@router-fw-old.local.net-space.pl>
 <20100806163408.GA8678@phenom.dumpdata.com>
 <4C5C6067.1000403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5C6067.1000403@goop.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Can you repost a patch that is on top of a virgin tree please?
> 
> I just thanked him for posting a delta ;)  I've pushed this into
> xen/memory-hotplug so you can easily generate a complete diff with
> "git diff v2.6.34..xen/memory-hotplug".

Ahh, I didn't know you had it in your tree already. Will use the git
diff for a more careful analysis.
