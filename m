Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab0FFBbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 21:31:13 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:34191 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768Ab0FFBbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 21:31:12 -0400
Date: Sun, 6 Jun 2010 02:29:59 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, mingo@elte.hu,
       simon.kagstrom@netinsight.net, David.Woodhouse@intel.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v3] printk: fix delayed messages from CPU hotplug events
Message-ID: <20100606012958.GA6169@linux-mips.org>
References: <ee1bf4f9c158983acad0a4548229586128afad67@localhost>
 <20100603225824.8de77fba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603225824.8de77fba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:58:24PM -0700, Andrew Morton wrote:

Assuming everybody is happy now I've merged Andrew's patch into Kevin's
patch and dropped it into the linux-queue tree and my tree for -next.
If nobody objects I intend to send the patch to Linus in about a week
or so.

Andrew, your patch had no Signed-off-by ;-)

Thanks everbody,

  Ralf
