Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1ELQ1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:27:12 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:36325 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757426Ab1ELQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:27:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: erIXHCsVM1mWyA5kYMkNzgR9a6sSDrFC8xMHkaNvJW_kh6X
 i6CU9kGaaCfFZjofISP9DS8cD.BBt0n.x9cE2rVhowMcwyke7FxxE5vN6r8k
 dgaKvLZmuyHaBLO6cHSSi3PXs6DsRP7pSVA41eI7XoolONfjhhkguFZJ0FsF
 7oGVhob.BqiirrPr8W1k9bfZK4O1yHifWm2kVbwL5XHOr5YQGK_Tfcmr31jq
 8bmcbIRGGzgZz_w96UBstxg_uFZPjtXjFlAx2n5D5SuuQtyxU44lEhccEc8y
 XNz422v_0sjXQlpK4UbtiLxrGNMeUX5rSqq1E3smcgQL61LZZ
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 11:27:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <1305216023.2575.54.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105121121120.26013@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>  <1305127773-10570-4-git-send-email-mgorman@suse.de>  <alpine.DEB.2.00.1105120942050.24560@router.home>  <1305213359.2575.46.camel@mulgrave.site>  <alpine.DEB.2.00.1105121024350.26013@router.home>
  <1305214993.2575.50.camel@mulgrave.site> <20110512154649.GB4559@redhat.com> <1305216023.2575.54.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, James Bottomley wrote:

> However, the fact remains that this seems to be a slub problem and it
> needs fixing.

Why are you so fixed on slub in these matters? Its an key component but
there is a high interaction with other subsystems. There was no recent
change in slub that changed the order of allocations. There were changes
affecting the reclaim logic. Slub has been working just fine with the
existing allocation schemes for a long time.

