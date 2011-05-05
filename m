Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1EEDia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 23:38:30 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:48038 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1EEDi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 23:38:29 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Date: Wed, 4 May 2011 23:37:46 -0400
Subject: RE: [PATCH] getdelays: show average CPU/IO/SWAP/RECLAIM delays
Thread-Topic: [PATCH] getdelays: show average CPU/IO/SWAP/RECLAIM delays
Thread-Index: AcwI0bvVNHwtAatPTWm+QbINBZYiHgCAiOrw
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C3DF8133D@USINDEVS02.corp.hds.com>
References: <20110502140257.GA12780@localhost>
In-Reply-To: <20110502140257.GA12780@localhost>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 10:02 AM, Wu Fengguang wrote: 
> I find it very handy to show the average delays in milliseconds.
> 
> Example output (on 100 concurrent dd reading sparse files):
> 
> CPU             count     real total  virtual total    delay total  delay average
>                   986     3223509952     3207643301    38863410579         39.415ms
> IO              count    delay total  delay average
>                     0              0              0ms
> SWAP            count    delay total  delay average
>                     0              0              0ms
> RECLAIM         count    delay total  delay average
>                  1059     5131834899              4ms
> dd: read=0, write=0, cancelled_write=0
> 
> CC: Mel Gorman <mel@linux.vnet.ibm.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

This is useful for me.

Reviewed-by: Satoru Moriya <satoru.moriya@hds.com>

