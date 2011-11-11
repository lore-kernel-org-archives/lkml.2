Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1KKGuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 01:50:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1KKGuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 01:50:11 -0500
Date: Fri, 11 Nov 2011 07:50:03 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5]thp: improve the error code path
Message-ID: <20111111065003.GO5075@redhat.com>
References: <1319593680.22361.145.camel@sli10-conroe>
 <1320643049.22361.204.camel@sli10-conroe>
 <20111110021853.GQ5075@redhat.com>
 <1320892395.22361.229.camel@sli10-conroe>
 <alpine.DEB.2.00.1111091828500.32414@chino.kir.corp.google.com>
 <20111110030646.GT5075@redhat.com>
 <alpine.DEB.2.00.1111092039110.27280@chino.kir.corp.google.com>
 <1320904609.22361.239.camel@sli10-conroe>
 <20111110141412.GW5075@redhat.com>
 <1320993217.22361.253.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320993217.22361.253.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 02:33:37PM +0800, Shaohua Li wrote:
> Improve the error code path. Delete unnecessary sysfs file for example.
> Also remove the #ifdef xxx to make code better.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  mm/huge_memory.c |   71 ++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 50 insertions(+), 21 deletions(-)

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
