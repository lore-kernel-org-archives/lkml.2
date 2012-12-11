Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2LKTd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:33:59 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52663 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2LKTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:33:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6923"; a="11494165"
X-IronPort-AV: E=McAfee;i="5400,1158,6923"; a="383613918"
Date: Tue, 11 Dec 2012 11:36:46 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: Jason Baron <jbaron@redhat.com>, Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-wireless@vger.kernel.org>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Message-ID: <20121211193646.GS15974@pogo>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1353263740.28214.2.camel@joe-AO722>
 <20121120160845.GB31176@redhat.com>
 <3645415.mrRzvuvPFK@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3645415.mrRzvuvPFK@lx-vladimir>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 11:28:26AM +0200, Vladimir Kondratiev wrote:
> Hi Jason,
> 
> Do you have any update on the status for patches below?
> Where is it now? When do you expect it to merge? 3.8?
> I am waiting for this to merge before I can go on
> with my driver.

*poke*

  Luis
