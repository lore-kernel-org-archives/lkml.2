Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab0IIW67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:58:59 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34018 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0IIW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:58:55 -0400
Date: Fri, 10 Sep 2010 07:56:57 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Hugepage migration (v5)
Message-ID: <20100909225657.GA2790@spritzera.linux.bs1.fc.nec.co.jp>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100909123306.32134d5e@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100909123306.32134d5e@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 12:33:06PM +0200, Andi Kleen wrote:
> 
> I went over this patchkit again and it all looks good to me.
> I plan to merge it through my hwpoison tree.

Thank you.

> As far as I understand all earlier comments have been addressed
> with this revision, correct?

Yes. I've reflected all given comments.

> I am considering to fast track 10/10 (the page-types fix). 
> 
> I think the other bug fixes in the series are only for bugs added
> earlier in the series, correct?

Correct.

Thanks,
Naoya Horiguchi
