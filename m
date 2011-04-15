Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1DOFHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:07:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37952 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DOFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:07:54 -0400
Subject: Re: [PATCH] make sparse happy with gfp.h
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110415121424.F7A6.A69D9226@jp.fujitsu.com>
References: <20110414234216.9E31DBD9@kernel>
	 <20110415121424.F7A6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 14 Apr 2011 22:07:46 -0700
Message-ID: <1302844066.16562.1953.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 12:14 +0900, KOSAKI Motohiro wrote:
> >  #ifdef CONFIG_DEBUG_VM
> > -             BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > +     BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> >  #endif
> > -     }
> >       return z;
> 
> Why don't you use VM_BUG_ON?

I was just trying to make a minimal patch that did a single thing.

Feel free to submit another one that does that.  I'm sure there are a
couple more places that could use similar love.

-- Dave

