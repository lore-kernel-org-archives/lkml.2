Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0FXHw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:52:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0FXHwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:52:24 -0400
Subject: Re: [patch 06/52] fs: scale files_lock
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624030726.584973456@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030726.584973456@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 09:52:17 +0200
Message-ID: <1277365937.1875.883.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> 
> One difficulty with this approach is that a file can be removed from the list
> by another CPU. We must track which per-cpu list the file is on.  Scalability
> could suffer if files are frequently removed from different cpu's list.


Is this really a lot less complex than what I did with my fine-grained
locked list?


