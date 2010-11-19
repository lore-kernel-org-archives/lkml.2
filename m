Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0KSLGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:06:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:19428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0KSLGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:06:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,222,1288594800"; 
   d="scan'208";a="350816807"
Date: Fri, 19 Nov 2010 10:46:31 +0000
From: Alan Cox <alan@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liu Hong <hong.liu@intel.com>, Kalhan Trisal <kalhan.trisal@intel.com>
Subject: Re: [PATCH] misc/isl29020: Remove incorrect kfree in
 isl29020_remove()
Message-ID: <20101119104631.2c28da00@linux.intel.com>
In-Reply-To: <1290144437.23599.4.camel@mola>
References: <1290144437.23599.4.camel@mola>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 13:27:17 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> struct als_data *data is not used in this driver at all.
> 
> Also add a missing ">" character for MODULE_AUTHOR.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>

It stayed as NULL so the kfree was fine but it definitely wants removing
