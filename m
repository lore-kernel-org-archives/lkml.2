Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2EaA4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:56:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2EaAz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:55:57 -0400
Date: Wed, 30 May 2012 17:55:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -V7 01/14] hugetlb: rename max_hstate to
 hugetlb_max_hstate
In-Reply-To: <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205301755420.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
> subsystems like hugetlb controller in later patches.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Hillf Danton <dhillf@gmail.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>
