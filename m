Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040Ab2ILSGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:06:49 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39016 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761020Ab2ILSGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:06:44 -0400
Message-ID: <5050CF33.4000909@tilera.com>
Date: Wed, 12 Sep 2012 14:06:43 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Will Deacon <will.deacon@arm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <akpm@linux-foundation.org>, Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 3/3] mm: Introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com> <1347382036-18455-4-git-send-email-will.deacon@arm.com> <20120912153206.GT21579@dhcp22.suse.cz>
In-Reply-To: <20120912153206.GT21579@dhcp22.suse.cz>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2012 11:32 AM, Michal Hocko wrote:
> Makes sense if there are going to be more archs to support THP.

The tile architecture currently supports it in our in-house tree,
though we haven't returned it to the community yet.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
