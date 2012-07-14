Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2GNFTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 01:19:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:33921 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2GNFTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 01:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177207679"
Date: Sat, 14 Jul 2012 13:19:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault on ttm_init()
Message-ID: <20120714051943.GA29675@localhost>
References: <20120706144622.GA13387@localhost>
 <20120706144846.GA13505@localhost>
 <CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
 <CAPM=9tzUkUOkA8-RNA4rztUXuKREKYGJVR3=0oYM7ufR9kRacA@mail.gmail.com>
 <20120707020847.GA28771@localhost>
 <20120707153142.GA24787@localhost>
 <20120711044155.GA10438@localhost>
 <CAPM=9twZW2DnaeBEvwt5kk0dS85xJUqNHfUdGqXX8io+MTYw5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9twZW2DnaeBEvwt5kk0dS85xJUqNHfUdGqXX8io+MTYw5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Sat, Jul 14, 2012 at 01:33:45PM +1000, Dave Airlie wrote:
> Can you try this patch on top of the previous one?
> 
> I think it should fix it.

You are right, it works!  Thank you very much! :-)

Thanks,
Fengguang
