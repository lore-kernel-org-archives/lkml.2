Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1GNNoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:44:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:43748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab1GNNod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,529,1304319600"; 
   d="scan'208";a="27914214"
Date: Thu, 14 Jul 2011 14:44:20 +0100
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acct_arg_size: ptl is no longer needed for
 add_mm_counter()
Message-ID: <20110714144420.38c3d539@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110713193935.GA18026@redhat.com>
References: <20110713193935.GA18026@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 21:39:35 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> acct_arg_size() takes ->page_table_lock around add_mm_counter()
> if !SPLIT_RSS_COUNTING. This is no needed after 172703b0
> "mm: delete non-atomic mm counter implementation".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Oops, good catch. Thanks!

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
