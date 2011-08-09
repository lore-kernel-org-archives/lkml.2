Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1HISly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:41:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36250 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1HISlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:41:52 -0400
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Aug 2011 20:41:05 +0200
In-Reply-To: <20110809181543.GG6482@redhat.com>
References: <20110806084447.388624428@intel.com>
	 <20110806094527.136636891@intel.com> <20110809181543.GG6482@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312915266.1083.75.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 14:15 -0400, Vivek Goyal wrote:
> 
> So far bw had pos_ratio as value now it will be replaced with actual
> bandwidth as value. It makes code confusing. So using pos_ratio will
> help. 

Agreed on consistency, also I'm not sure bandwidth is the right term
here to begin with, its a pages/s unit and I think rate would be better
here. But whatever ;-)
