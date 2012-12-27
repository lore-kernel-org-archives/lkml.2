Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2L0W2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:28:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56676 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0W2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:28:15 -0500
Date: Thu, 27 Dec 2012 14:28:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm, sparse: don't check return value of alloc_bootmem
 calls
In-Reply-To: <1356293711-23864-3-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.00.1212271428020.18214@chino.kir.corp.google.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <1356293711-23864-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2012, Sasha Levin wrote:

> There's no need to check the result of alloc_bootmem() functions since
> they'll panic if allocation fails.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: David Rientjes <rientjes@google.com>
