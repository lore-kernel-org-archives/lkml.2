Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1HZNTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:19:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab1HZNTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:05 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Aug 2011 15:18:21 +0200
In-Reply-To: <20110826131341.GA7114@localhost>
References: <20110823141504.GA15949@localhost>
	 <20110823174757.GC15820@redhat.com> <20110824001257.GA6349@localhost>
	 <1314202378.6925.48.camel@twins> <20110826001846.GA6118@localhost>
	 <1314349469.26922.24.camel@twins> <20110826100428.GA7996@localhost>
	 <20110826112637.GA17785@localhost> <1314360710.11049.1.camel@twins>
	 <20110826122057.GA32711@localhost> <20110826131341.GA7114@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314364701.12445.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 21:13 +0800, Wu Fengguang wrote:
> We got similar result as in the read disturber case, even though one
> disturbs N and the other impacts writeout bandwith.  The original
> patchset is consistently performing much better :) 

It does indeed, and I figure on these timescales it makes sense to
assumes N is a constant. Fair enough, thanks!
