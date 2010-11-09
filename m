Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0KIBtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:49:53 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:53164 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0KIBtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:49:52 -0500
Date: Tue, 9 Nov 2010 02:49:35 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: correct memcg_hierarchical_free_pages() return
 type
Message-ID: <20101109014935.GQ23393@cmpxchg.org>
References: <1289265430-7190-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289265430-7190-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 05:17:10PM -0800, Greg Thelen wrote:
> memcg_hierarchical_free_pages() returns a page count and thus
> should return unsigned long to be consistent with the rest of
> mm code.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
