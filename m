Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0GUNgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:36:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:14325 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0GUNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,238,1278313200"; 
   d="scan'208";a="588303294"
Message-ID: <4C46F7E9.3070200@linux.intel.com>
Date: Wed, 21 Jul 2010 06:36:41 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel/panic.c warn_slowpath_common  printk timestamp weirdness
References: <62021.1279716868@localhost>
In-Reply-To: <62021.1279716868@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/2010 5:54 AM, Valdis.Kletnieks@vt.edu wrote:
> Seeing this on my Dell Latitude.  The timestamps from the 'cut here' and
> WARNING lines are different even though they're issued by sequential lines in
> panic.c - but then the printk timestamps remain identical even through an
> *entire second* WARN call.  Is somebody blocking clock interrupts and failing
> to re-enable them, or is something different going on here?
>
> [42875.543219] ------------[ cut here ]------------
> [42875.544006] WARNING: at lib/plist.c:57 plist_check_head+0x47/0x114()
>    

> [42875.544006] WARNING: at lib/plist.c:57 plist_check_head+0x47/0x114()
> [42875.544006] Hardware name: Latitude E6500
>    

> [42882.428016] ------------[ cut here ]------------
> [42882.428016] WARNING: at lib/plist.c:57 plist_check_head+0x47/0x114()
>    


Maybe I have not have had coffee yet.. but I don't see the one second 
jump in the three cases you mailed...

