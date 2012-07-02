Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab2GBK4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:56:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995Ab2GBK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:56:03 -0400
Date: Mon, 2 Jul 2012 03:55:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Feng Tang <feng.tang@intel.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        sfr@canb.auug.org.au, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: Fix a tpyo in commit 8c138b "slab: Get rid of
 obj_size macro"
In-Reply-To: <1341210550-11038-1-git-send-email-feng.tang@intel.com>
Message-ID: <alpine.DEB.2.00.1207020355180.14758@chino.kir.corp.google.com>
References: <1341210550-11038-1-git-send-email-feng.tang@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Feng Tang wrote:

> Commit  8c138b only sits in Pekka's and linux-next tree now, which tries
> to replace obj_size(cachep) with cachep->object_size, but has a typo in
> kmem_cache_free() by using "size" instead of "object_size", which casues
> some regressions.
> 

If you have a specific regression that you'd like to describe, that would 
be helpful here.  "Some regressions" isn't descriptive.

> Reported-and-tested-by: Fengguang Wu <wfg@linux.intel.com>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>
