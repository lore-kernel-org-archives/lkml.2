Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab2GLHmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:42:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:53559 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130Ab2GLHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167118260"
Date: Thu, 12 Jul 2012 10:42:02 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH v3 1/8] bluetooth: /proc/net/ entries for bluetooth
 protocols
Message-ID: <20120712074200.GA12931@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120710140400.GA15795@aemeltch-MOBL1>
 <20120711.135831.1712662939552441872.yamato@redhat.com>
 <20120711112308.GA3044@aemeltch-MOBL1>
 <20120711.211906.1087916687452547370.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711.211906.1087916687452547370.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Wed, Jul 11, 2012 at 09:19:06PM +0900, Masatake YAMATO wrote:
> > I've tested the patch and it creates entries in /proc/net
> 
> Thanks.
>  
> > BTW: Shall lsof be able to identify l2cap protocol?
> > 
> > for l2test it prints: "can't identify protocol"
> 
> No. I'll work on lsof side after the kernel side
> patches are merged to the main line.

OK, patch looks good though I would eliminate 2 new sparse warnings with
__acquires and __releases attributes.

net/bluetooth/af_bluetooth.c:540:13: warning: context imbalance in
'bt_seq_start' - wrong count at exit
net/bluetooth/af_bluetooth.c:557:13: warning: context imbalance in
'bt_seq_stop' - unexpected unlock

Best regards 
Andrei Emeltchenko

