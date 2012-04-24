Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2DXIrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:47:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46559 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab2DXIrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:47:07 -0400
Date: Tue, 24 Apr 2012 09:47:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm:vmstat - Removed debug fs entries on failure of
 file creation and made extfrag_debug_root dentry local
Message-ID: <20120424084703.GC3095@csn.ul.ie>
References: <1335216593-8890-1-git-send-email-sasikanth.v19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1335216593-8890-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 02:59:53AM +0530, Sasikantha babu wrote:
> Removed debug fs files and directory on failure. Since no one using "extfrag_debug_root" dentry outside of function
> extfrag_debug_init made it local to the function.
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
