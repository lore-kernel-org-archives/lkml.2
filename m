Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1G0Vfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:35:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47435 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1G0Vfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:35:51 -0400
Date: Wed, 27 Jul 2011 23:35:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dehrenberg@google.com
Subject: Re: RFC: Micro-optimize direct IO submission path
Message-ID: <20110727213548.GD8006@one.firstfloor.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org> <20110727210606.GA12714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727210606.GA12714@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 05:06:06PM -0400, Christoph Hellwig wrote:
> Any chance you could resend these against current mainline?  It would
> be sad to miss these easy optimizations.

I was waiting for the benchmarkers to rerun them.

I had done an additional prefetch optimization that seemed to give
1% more on a big benchmark for one result, but there was another
suspicious one.

Hopefully soon.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
