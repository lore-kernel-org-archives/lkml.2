Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab2EWVqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:46:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933288Ab2EWVq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:46:28 -0400
Message-ID: <4FBD5A86.70701@redhat.com>
Date: Wed, 23 May 2012 17:45:42 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Satoru Moriya <satoru.moriya@hds.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Richard Davies <richard.davies@elastichosts.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH RESEND] avoid swapping out with swappiness==0
References: <65795E11DBF1E645A09CEC7EAEE94B9C015A48DF62@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C015A48DF62@USINDEVS02.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 04:41 PM, Satoru Moriya wrote:

> The patch may not be perfect but, at least, we can improve
> the kernel behavior in the enough filebacked memory case
> with this patch. I believe it's better than nothing.

Agreed.

> Do you have any comments about it?

Only one comment, and it's for Andrew :)

> Signed-off-by: Satoru Moriya<satoru.moriya@hds.com>
> Acked-by: Minchan Kim<minchan@kernel.org>
> Acked-by: Rik van Riel<riel@redhat.com>

Andrew, you can turn my Acked-by into a

Reviewed-by: Rik van Riel<riel@redhat.com>

This is functionality that many people seem to want, and
will not break anything current users typically do.

-- 
All rights reversed
