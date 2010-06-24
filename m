Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0FXI6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:58:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0FXI6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:58:17 -0400
Subject: Re: [patch 30/52] fs: icache lock lru/writeback lists
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624030730.419497214@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030730.419497214@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 10:58:08 +0200
Message-ID: <1277369888.1875.929.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> +       assert_spin_locked(&wb_inode_list_lock);

There's also lockdep_assert_held() which also validates we're the owner.
