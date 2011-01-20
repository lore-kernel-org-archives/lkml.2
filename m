Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1ATCMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:12:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:26372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1ATCMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:12:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,347,1291622400"; 
   d="scan'208";a="377139115"
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
From: Shaohua Li <shaohua.li@intel.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: "Shi, Alex" <alex.shi@intel.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110119143214.GA3043@thunk.org>
References: <1295402148.4773.143.camel@debian>
	 <20110119143214.GA3043@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 10:12:04 +0800
Message-ID: <1295489524.1949.884.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 22:32 +0800, Ted Ts'o wrote:
> On Wed, Jan 19, 2011 at 09:55:48AM +0800, Alex,Shi wrote:
> > Shaohua and I tested kernel building performance on latest kernel. and
> > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > system. 
> 
> What kerenl version were you comparing against?  And what were you
> using to benchmark this performance drop?  I'm curious what your
> workload was; I'm guesisng it was some kind of mixed read/write
> workload?  Were there any fsync()'s involved?
2.6.36 vs 2.6.37. this exists in 2.6.37-rc1. it's a kbuild, no a mixed
read/write workload. kbuild hasn't fsync involved

Thanks,
Shaohua


