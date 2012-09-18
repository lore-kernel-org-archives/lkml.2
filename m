Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2IRVui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:50:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:41430 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab2IRVuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,445,1344236400"; 
   d="scan'208";a="146486445"
Date: Tue, 18 Sep 2012 14:50:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] memory.txt: remove stray information
Message-ID: <20120918215036.GP4092@tassilo.jf.intel.com>
References: <alpine.LNX.2.00.1209182336280.31149@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1209182336280.31149@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems to me like we are not losing anything by completely removing the
> file now.

The stuff at the end still seems useful, down from
"There are other memory problems which Linux cannot deal with...."

The rest could go I agree.

-Andi
