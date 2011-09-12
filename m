Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1ILKXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:23:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1ILKXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:23:02 -0400
Subject: Re: [PATCH 13/18] writeback: limit max dirty pause time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Sep 2011 12:22:31 +0200
In-Reply-To: <20110907023505.GB13755@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.329482509@intel.com> <1315320726.14232.11.camel@twins>
	 <20110907023505.GB13755@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315822951.26517.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 10:35 +0800, Wu Fengguang wrote:
> So yeah, the HZ value does impact the minimal available sleep time...

There's always schedule_hrtimeout() and we could trivially add a
io_schedule_hrtimeout() variant if you need it.
