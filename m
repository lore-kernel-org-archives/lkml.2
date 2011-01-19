Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1ASOO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:14:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab1ASOOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:14:24 -0500
Date: Wed, 19 Jan 2011 09:14:02 -0500
From: Josef Bacik <josef@redhat.com>
To: Liuwenyi <qingshenlwy@gmail.com>
Cc: strongzgy@gmail.com, onlyflyer@gmail.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com,
        akpm@linux-foundation.org, miaox@cn.fujitsu.com, josef@redhat.com,
        chris.mason@oracle.com, Yang Ruirui <ruirui.r.yang@tieto.com>,
        meego-kernel@meego.com
Subject: Re: [PATCH] Avoid a NULL pointer in btrfs
Message-ID: <20110119141334.GA2544@localhost.localdomain>
References: <4D36F04D.70505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D36F04D.70505@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:08:13PM +0800, Liuwenyi wrote:
> In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
> null pointer in test_range_bit() while lock the spinlock.
> 
> So, It is necessary to add a pointer check into test_range_bit()
> 


NAK, the tree shouldn't be null coming into this function, something else is
going wrong.  What oops is this?  Thanks,

Josef
