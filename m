Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2GKJtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:49:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:32419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2GKJtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:49:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="164192969"
Date: Wed, 11 Jul 2012 12:49:43 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH v3 6/8] bluetooth: Added /proc/net/l2cap via
 bt_procfs_init()
Message-ID: <20120711094936.GA9755@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120711.135831.1712662939552441872.yamato@redhat.com>
 <20120711.140337.6492431783697495.yamato@redhat.com>
 <20120711084824.GA3470@aemeltch-MOBL1>
 <20120711.181931.1000444653721042650.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711.181931.1000444653721042650.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Wed, Jul 11, 2012 at 06:19:31PM +0900, Masatake YAMATO wrote:
> Andrei, thank you for taking time.
> 
> I've rebased again and I applied my patches with git am.
> They are applied without problem.
> 
> I've regenerated the patches again and compared the new
> ones with the older ones.
> 
> About
> 
> 	[PATCH v3 6/8] bluetooth: Added /proc/net/l2cap via bt_procfs_init()
> 
> One line slided. I've paste the new one to this mail.

Thanks, this one works.

>  About 
> 
>         [PATCH v3 7/8] bluetooth: Added /proc/net/rfcomm via bt_procfs_init()
> 
> I cannot find any change between new one and older one.
> What can I do?

Sorry, my fault, rfcomm patch is OK, I was applying it second time...

Best regards 
Andrei Emeltchenko 

