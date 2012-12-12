Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2LLS2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:28:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab2LLS2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:28:46 -0500
Date: Wed, 12 Dec 2012 13:28:38 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Durgadoss R <durgadoss.r@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: Thermal: Add a thermal notifier for user space
Message-ID: <20121212182838.GA7497@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>,
	Zhang Rui <rui.zhang@intel.com>
References: <20121212180547.F12BE6606F0@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212180547.F12BE6606F0@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 06:05:47PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=1cc807a234cb988d69ba18f6a3a1c68d71e54bed
 > Commit:     1cc807a234cb988d69ba18f6a3a1c68d71e54bed
 > Parent:     e151a202a084f9f4310d1aa4398325c56ca95fda
 > Author:     Durgadoss R <durgadoss.r@intel.com>
 > AuthorDate: Tue Sep 18 11:05:03 2012 +0530
 > Committer:  Zhang Rui <rui.zhang@intel.com>
 > CommitDate: Mon Nov 5 14:00:08 2012 +0800
 > 
 >     Thermal: Add a thermal notifier for user space
 >     
 >     This patch registers a governor which will let the
 >     user land manage the platform thermals. Whenever a
 >     trip happens, this governor just notifies the user
 >     space using kobj_uevent().
 >     
 >     Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
 >     Signed-off-by: Zhang Rui <rui.zhang@intel.com>

 
 > +config USER_SPACE
 > +	bool "User_space thermal governor"
 > +	depends on THERMAL
 > +	help
 > +	  Enable this to let the user space manage the platform thermals.

This is terribly generic sounding.  Might I suggest THERMAL_USER_SPACE instead ?

	Dave

