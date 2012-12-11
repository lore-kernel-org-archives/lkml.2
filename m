Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2LKUIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:08:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2LKUIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:08:49 -0500
Date: Tue, 11 Dec 2012 15:08:31 -0500
From: Jason Baron <jbaron@redhat.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        gregkh@linuxfoundation.org
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Message-ID: <20121211200831.GD11815@redhat.com>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1353263740.28214.2.camel@joe-AO722>
 <20121120160845.GB31176@redhat.com>
 <3645415.mrRzvuvPFK@lx-vladimir>
 <20121211193646.GS15974@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211193646.GS15974@pogo>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 11:36:46AM -0800, Luis R. Rodriguez wrote:
> On Tue, Dec 04, 2012 at 11:28:26AM +0200, Vladimir Kondratiev wrote:
> > Hi Jason,
> > 
> > Do you have any update on the status for patches below?
> > Where is it now? When do you expect it to merge? 3.8?
> > I am waiting for this to merge before I can go on
> > with my driver.
> 
> *poke*
> 
>   Luis

Hi Luis,

Yes, I posted this patch, along with 2 others last week for Greg to
pull. I believe these are too late for the 3.8 merge window. Perhaps,
Greg can comment. Here's a link to the post:

http://marc.info/?l=linux-kernel&m=135474417810281&w=2

Thanks,

-Jason
