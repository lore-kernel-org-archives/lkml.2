Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1IVVXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:23:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56277
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab1IVVXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:23:33 -0400
Date: Thu, 22 Sep 2011 17:23:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 0/3] Replace kmalloc with vmalloc in seq_files
Message-ID: <20110922212328.GA30679@infradead.org>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316725029-22737-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 01:57:06PM -0700, Colin Cross wrote:
> seq_files are often used for debugging data.  When the system is under
> memory pressure, and dumping debugging data starts trying to allocate
> large physically contiguous buffers, it often makes the problem worse.

Please fix the instances that you see issues with by using the full
seq_file interface which was designed for his instead of the simplified
"single" interface that is only designed for small amounts of data.

