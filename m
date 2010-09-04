Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0IDJrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 05:47:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:50335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab0IDJrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 05:47:42 -0400
Message-ID: <4C8215B9.8060606@kernel.org>
Date: Sat, 04 Sep 2010 11:47:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] percpu: use percpu allocator on UP too
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org> <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org> <4C8121BC.7040609@kernel.org> <4C81ED2C.6000304@cs.helsinki.fi>
In-Reply-To: <4C81ED2C.6000304@cs.helsinki.fi>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 04 Sep 2010 09:47:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/04/2010 08:54 AM, Pekka Enberg wrote:
> Is this going into some public append-only branch I could
> cherry-pick the changeset from to my 'slub/cleanups' branch?

I'll put it into percpu#for-next once Linus pulls in the currently
pending set of fixes.  I'll let you know.

Thanks.

-- 
tejun
