Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2LDJ2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:28:34 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57839 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2LDJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:28:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6915"; a="10342391"
X-IronPort-AV: E=McAfee;i="5400,1158,6915"; a="352092604"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Jason Baron <jbaron@redhat.com>
CC: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-wireless@vger.kernel.org>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Tue, 4 Dec 2012 11:28:26 +0200
Message-ID: <3645415.mrRzvuvPFK@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.9.2 (Linux/3.5.0-19-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121120160845.GB31176@redhat.com>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1353263740.28214.2.camel@joe-AO722> <20121120160845.GB31176@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Do you have any update on the status for patches below?
Where is it now? When do you expect it to merge? 3.8?
I am waiting for this to merge before I can go on
with my driver.

Thanks, Vladimir

On Tuesday, November 20, 2012 11:08:45 AM Jason Baron wrote:
> On Sun, Nov 18, 2012 at 10:35:40AM -0800, Joe Perches wrote:
> > On Sun, 2012-11-18 at 19:01 +0200, Vladimir Kondratiev wrote:
> > > In case this option wins, patch follows. There is no need for
> > > 2-nd one to fix existing drivers.
> > 
> > Thanks Vladimir.
> > 
> > 
> 
> Yes, thanks. I've pulled in this patch, and posted a dynamic debug tree
> at: git clone git://github.com/jibaron/ddebug.git
> 
> I will push the collected set of patches to Greg.
> 
> I also added a couple of patches there to convert dynamic debug to use
> 'jump labels', which shows good results.
> 
> Thanks,
> 
> -Jason
