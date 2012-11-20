Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2KTQJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:09:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab2KTQJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:09:06 -0500
Date: Tue, 20 Nov 2012 11:08:45 -0500
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Vladimir Kondratiev <vkondrat@qti.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Message-ID: <20121120160845.GB31176@redhat.com>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1353249531.15959.10.camel@joe-AO722>
 <1380367.3QOKJVXxFC@lx-vladimir>
 <2748656.Zh8WY0OSmS@lx-vladimir>
 <1353263740.28214.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353263740.28214.2.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 10:35:40AM -0800, Joe Perches wrote:
> On Sun, 2012-11-18 at 19:01 +0200, Vladimir Kondratiev wrote:
> > In case this option wins, patch follows. There is no need for
> > 2-nd one to fix existing drivers.
> 
> Thanks Vladimir.
> 
> 

Yes, thanks. I've pulled in this patch, and posted a dynamic debug tree
at: git clone git://github.com/jibaron/ddebug.git

I will push the collected set of patches to Greg.

I also added a couple of patches there to convert dynamic debug to use
'jump labels', which shows good results.

Thanks,

-Jason
