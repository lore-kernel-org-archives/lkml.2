Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1AYFPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:15:32 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49289 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1AYFPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:15:31 -0500
Date: Tue, 25 Jan 2011 10:45:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org, akpm@linux-foundation.org
Cc: npiggin@kernel.dk, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/2] Refactor zone_reclaim code (v4)
Message-ID: <20110125051512.GO2897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2011-01-25 10:40:09]:

> Changelog v3
> 1. Renamed zone_reclaim_unmapped_pages to zone_reclaim_pages
> 
> Refactor zone_reclaim, move reusable functionality outside
> of zone_reclaim. Make zone_reclaim_unmapped_pages modular
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>

I got the patch numbering wrong due to a internet connection going down
in the middle of stg mail, restarting with specified patches goofed up
the numbering. I can resend the patches with the correct numbering if
desired. This patch should be numbered 2/3

-- 
	Three Cheers,
	Balbir
