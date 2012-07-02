Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab2GBK2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:28:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57650 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950Ab2GBK2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:28:38 -0400
Message-ID: <4FF17733.6020703@parallels.com>
Date: Mon, 2 Jul 2012 14:25:55 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        <fengguang.wu@intel.com>, <sfr@canb.auug.org.au>, <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: Fix a tpyo in commit 8c138b "slab: Get rid of obj_size
 macro"
References: <1341210550-11038-1-git-send-email-feng.tang@intel.com> <4FF1714A.7050400@parallels.com>
In-Reply-To: <4FF1714A.7050400@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I saw another bug in a patch that ended up not getting in, and was
> reported to Christoph, that was exactly due to a typo between size and
> object-size.
> 
> So first:
> 
> Acked-by: Glauber Costa <glommer@parallels.com>
> 
> But this also means that that confusion can have been made in other
> points. I suggest we take an extensive look into that to make sure there
> aren't more.
> 

Which I just did. I also tried to pay attention to another simple
conversion spots like that. We seem to be fine.
