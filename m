Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0I3CGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:06:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60440 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0I3CGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:06:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 30 Sep 2010 11:00:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
        Matt Tolentino <matthew.e.tolentino@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Badari Pulavarty <pbadari@us.ibm.com>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [Patch 2/3] Introduce find_memory_block_hinted which utilizes
 kset_find_obj_hinted.
Message-Id: <20100930110046.a4582ead.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100929190115.632695677@gulag1.americas.sgi.com>
References: <20100929190053.992911934@gulag1.americas.sgi.com>
	<20100929190115.632695677@gulag1.americas.sgi.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 14:00:55 -0500
Robin Holt <holt@sgi.com> wrote:

> 
> Introduce a find_memory_block_hinted() which utilizes the
> recently added kset_find_obj_hinted().
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Dave Hansen <haveblue@us.ibm.com>
> To: Matt Tolentino <matthew.e.tolentino@intel.com>
> Cc: lkml <linux-kernel@vger.kernel.org>
> 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

