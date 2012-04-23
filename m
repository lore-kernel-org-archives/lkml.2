Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2DWVhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:37:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54659 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2DWVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:37:51 -0400
Date: Mon, 23 Apr 2012 14:37:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasikantha babu <sasikanth.v19@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm:vmstat - Removed debug fs entries on failure of
 file creation and made extfrag_debug_root dentry local
In-Reply-To: <1335216593-8890-1-git-send-email-sasikanth.v19@gmail.com>
Message-ID: <alpine.DEB.2.00.1204231437370.11602@chino.kir.corp.google.com>
References: <1335216593-8890-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Sasikantha babu wrote:

> Removed debug fs files and directory on failure. Since no one using "extfrag_debug_root" dentry outside of function
> extfrag_debug_init made it local to the function.
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
